import 'dart:async';

import '../../../core/error/error_mapper.dart';
import '../../../core/error/result.dart';
import '../../../core/logging/app_logger.dart';
import '../../../shared/utils/id_generator.dart';
import '../../file/domain/attachment.dart';
import '../../file/domain/file_services.dart';
import '../../voice/domain/speech_transcriber.dart';
import '../domain/chat_cache.dart';
import '../domain/chat_provider.dart';
import '../domain/chat_repository.dart';
import '../domain/entities/chat_event.dart';
import '../domain/entities/conversation.dart';
import '../domain/entities/message.dart';
import '../domain/entities/participant.dart';
import '../domain/extensions/ai_extensions.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this._provider,
    required this._cache,
    required this.self,
    IdGenerator? ids,
    this._uploader,
    this._logger = const SilentLogger(),
    DateTime Function()? clock,
    this.pageSize = 30,
    this.historyWindow = 20,
    this._transcriber,
    String? Function()? transcriptionLanguage,
  }) : _transcriptionLanguage = transcriptionLanguage ?? (() => null),
       _ids = ids ?? RandomIdGenerator(),
       _clock = clock ?? DateTime.now {
    _incoming = _provider.incoming.listen(
      _apply,
      onError: (Object e) =>
          _logger.warning('Incoming chat stream error', tag: 'chat', error: e),
    );
  }

  final ChatProvider _provider;
  final ChatCache _cache;
  final IdGenerator _ids;
  final FileUploader? _uploader;

  /// Turns voice notes into the message text; null sends audio only.
  final SpeechTranscriber? _transcriber;
  final String? Function() _transcriptionLanguage;
  final AppLogger _logger;
  final DateTime Function() _clock;

  @override
  final Participant self;

  final int pageSize;

  /// How many recent messages are passed to providers as context.
  final int historyWindow;

  late final StreamSubscription<ChatEvent> _incoming;
  final Map<String, String?> _cursors = {};
  final Set<String> _loaded = {};
  final Map<String, Set<Participant>> _typing = {};
  final _typingChanges = StreamController<String>.broadcast();

  @override
  ChatProviderInfo get providerInfo => _provider.info;

  // ---------------------------------------------------------------------------
  // Conversations

  @override
  Stream<List<Conversation>> watchConversations() =>
      _cache.watchConversations();

  @override
  Future<Result<void>> refreshConversations() => guard(() async {
    final conversations = await _provider.fetchConversations();
    await _cache.putConversations(conversations);
  });

  // ---------------------------------------------------------------------------
  // Messages & pagination

  @override
  Stream<List<Message>> watchMessages(String conversationId) =>
      _cache.watchMessages(conversationId);

  @override
  Stream<Set<Participant>> watchTyping(String conversationId) =>
      Stream.multi((controller) {
        controller.add(_typingOf(conversationId));
        final sub = _typingChanges.stream
            .where((id) => id == conversationId)
            .listen((_) => controller.add(_typingOf(conversationId)));
        controller.onCancel = sub.cancel;
      });

  Set<Participant> _typingOf(String id) => Set.unmodifiable(_typing[id] ?? {});

  @override
  bool hasMore(String conversationId) =>
      !_loaded.contains(conversationId) || _cursors[conversationId] != null;

  @override
  Future<Result<void>> loadInitial(String conversationId) async {
    if (_loaded.contains(conversationId)) return const Ok(null);
    return guard(() => _fetchPage(conversationId, before: null));
  }

  @override
  Future<Result<bool>> loadOlder(String conversationId) async {
    if (!_loaded.contains(conversationId)) {
      final initial = await loadInitial(conversationId);
      if (initial case Err(:final failure)) return Err(failure);
      return Ok(hasMore(conversationId));
    }
    final cursor = _cursors[conversationId];
    if (cursor == null) return const Ok(false);
    return guard(() async {
      await _fetchPage(conversationId, before: cursor);
      return hasMore(conversationId);
    });
  }

  Future<void> _fetchPage(String conversationId, {String? before}) async {
    final page = await _provider.fetchMessages(
      conversationId,
      before: before,
      limit: pageSize,
    );
    await _cache.upsertMessages(conversationId, page.items);
    _cursors[conversationId] = page.nextCursor;
    _loaded.add(conversationId);
  }

  // ---------------------------------------------------------------------------
  // Sending

  @override
  Future<void> sendMessage(
    String conversationId, {
    String text = '',
    List<Attachment> attachments = const [],
    ReplyReference? replyTo,
  }) async {
    final content = text.trim();
    if (content.isEmpty && attachments.isEmpty) return;
    final message = Message(
      id: _ids.next(),
      conversationId: conversationId,
      sender: self,
      createdAt: _clock(),
      type: content.isEmpty ? _typeFor(attachments.first) : MessageType.text,
      content: content,
      attachments: attachments,
      replyTo: replyTo,
      status: MessageStatus.sending,
    );
    await _cache.upsertMessages(conversationId, [message]);
    await _touchConversation(message);
    await _deliver(message);
  }

  @override
  Future<void> retry(String conversationId, String messageId) async {
    final message = _cache.message(conversationId, messageId);
    if (message == null || !message.isFailed || message.sender.id != self.id) {
      return;
    }
    final resending = message.copyWith(status: MessageStatus.sending);
    await _cache.upsertMessages(conversationId, [resending]);
    await _deliver(resending);
  }

  Future<void> _deliver(Message message) async {
    var current = message;
    try {
      // The voice note is already on screen; its text arrives while the
      // audio uploads, and the provider gets the question as text.
      final transcribing = _transcribe(current);
      current = await _uploadAttachments(current);
      final transcript = await transcribing;
      if (transcript.isNotEmpty) {
        current =
            (_cache.message(current.conversationId, current.id) ?? current)
                .copyWith(content: transcript, type: MessageType.text);
        await _cache.upsertMessages(current.conversationId, [current]);
        await _touchConversation(current);
      }
      final outgoing = OutgoingMessage.fromMessage(
        current,
        history: _history(current.conversationId, excludeId: current.id),
      );
      await _consume(_provider.send(outgoing));
    } catch (error, stackTrace) {
      final failure = ErrorMapper.map(error, stackTrace);
      _logger.warning('Send failed: ${failure.message}', tag: 'chat');
      await _markFailed(current.conversationId, current.id);
    }
  }

  /// Text of a voice-only message; empty when there is nothing to
  /// transcribe or it fails (the audio is still sent).
  Future<String> _transcribe(Message message) async {
    final transcriber = _transcriber;
    if (transcriber == null || message.content.isNotEmpty) return '';
    final voice = message.attachments
        .where((a) => a.kind == AttachmentKind.audio && a.devicePath != null)
        .firstOrNull;
    if (voice == null) return '';
    try {
      return await transcriber.transcribe(
        voice.devicePath!,
        mimeType: voice.mimeType,
        language: _transcriptionLanguage(),
      );
    } on Object catch (error) {
      _logger.warning(
        'Voice note transcription failed',
        tag: 'chat',
        error: error,
      );
      return '';
    }
  }

  Future<Message> _uploadAttachments(Message message) async {
    final uploader = _uploader;
    if (uploader == null || !message.attachments.any((a) => a.needsUpload)) {
      return message;
    }
    var current = message;
    for (final attachment in message.attachments) {
      if (!attachment.needsUpload) continue;
      current = await _updateAttachment(
        current,
        attachment.copyWith(uploadStatus: UploadStatus.uploading),
      );
      try {
        final remote = await uploader.upload(
          attachment,
          onProgress: (p) => unawaited(
            _updateAttachment(
              current,
              attachment.copyWith(
                uploadStatus: UploadStatus.uploading,
                uploadProgress: p,
              ),
            ),
          ),
        );
        current = await _updateAttachment(
          current,
          attachment.copyWith(
            source: remote,
            uploadStatus: UploadStatus.uploaded,
            uploadProgress: 1,
          ),
        );
      } catch (_) {
        current = await _updateAttachment(
          current,
          attachment.copyWith(uploadStatus: UploadStatus.failed),
        );
        rethrow;
      }
    }
    return current;
  }

  Future<Message> _updateAttachment(Message message, Attachment updated) async {
    // Re-read so concurrent progress updates don't overwrite each other.
    final latest =
        _cache.message(message.conversationId, message.id) ?? message;
    final next = latest.copyWith(
      attachments: [
        for (final a in latest.attachments) a.id == updated.id ? updated : a,
      ],
    );
    await _cache.upsertMessages(message.conversationId, [next]);
    return next;
  }

  List<Message> _history(String conversationId, {String? excludeId}) {
    final all = _cache
        .messages(conversationId)
        .where((m) => m.id != excludeId && !m.isFailed)
        .toList();
    return all.length <= historyWindow
        ? all
        : all.sublist(all.length - historyWindow);
  }

  // ---------------------------------------------------------------------------
  // Generation controls

  @override
  Future<void> stopGeneration(String conversationId) async {
    final provider = _provider;
    if (provider is GenerativeChatProvider &&
        provider.info.supports(ChatCapability.stopGeneration)) {
      await provider.stopGeneration(conversationId);
    }
  }

  @override
  Future<void> regenerate(String conversationId) async {
    final provider = _provider;
    if (provider is! GenerativeChatProvider ||
        !provider.info.supports(ChatCapability.regenerate)) {
      return;
    }
    try {
      await _consume(
        provider.regenerate(conversationId, history: _history(conversationId)),
      );
    } catch (error) {
      _logger.warning('Regenerate failed', tag: 'chat', error: error);
    }
  }

  // ---------------------------------------------------------------------------
  // Event handling

  Future<void> _consume(Stream<ChatEvent> events) async {
    await for (final event in events) {
      await _apply(event);
    }
  }

  Future<void> _apply(ChatEvent event) async {
    switch (event) {
      case MessageUpserted(:final message, :final replacesId):
        if (replacesId != null && replacesId != message.id) {
          await _cache.replaceMessage(
            message.conversationId,
            replacesId,
            message,
          );
        } else {
          await _cache.upsertMessages(message.conversationId, [message]);
        }
        await _touchConversation(message);
      case MessageDelta(:final conversationId, :final messageId, :final delta):
        final existing = _cache.message(conversationId, messageId);
        if (existing == null) return;
        await _cache.upsertMessages(conversationId, [
          existing.copyWith(
            content: existing.content + delta,
            status: MessageStatus.streaming,
          ),
        ]);
      case MessageFailed(:final conversationId, :final messageId):
        await _markFailed(conversationId, messageId);
      case TypingChanged(
        :final conversationId,
        :final participant,
        :final isTyping,
      ):
        final set = _typing.putIfAbsent(conversationId, () => {});
        final changed = isTyping
            ? set.add(participant)
            : set.remove(participant);
        if (changed) _typingChanges.add(conversationId);
      case ConversationUpserted(:final conversation):
        await _cache.upsertConversation(conversation);
    }
  }

  Future<void> _markFailed(String conversationId, String messageId) async {
    final message = _cache.message(conversationId, messageId);
    if (message == null) return;
    await _cache.upsertMessages(conversationId, [
      message.copyWith(status: MessageStatus.failed),
    ]);
  }

  Future<void> _touchConversation(Message message) async {
    for (final conversation in _cache.conversations) {
      if (conversation.id == message.conversationId) {
        await _cache.upsertConversation(
          conversation.copyWith(
            lastMessage: message,
            updatedAt: message.createdAt.isAfter(conversation.updatedAt)
                ? message.createdAt
                : conversation.updatedAt,
          ),
        );
        return;
      }
    }
  }

  MessageType _typeFor(Attachment attachment) => switch (attachment.kind) {
    AttachmentKind.image => MessageType.image,
    AttachmentKind.video => MessageType.video,
    AttachmentKind.audio => MessageType.audio,
    AttachmentKind.document || AttachmentKind.other => MessageType.file,
  };

  // ---------------------------------------------------------------------------
  // Ratings & conversation management

  @override
  Future<Result<void>> rateMessage(
    String conversationId,
    String messageId,
    UserRating? rating,
  ) async {
    final rater = switch (_provider) {
      final MessageRater r
          when _provider.info.supports(ChatCapability.rating) =>
        r,
      _ => null,
    };
    final message = _cache.message(conversationId, messageId);
    if (rater == null || message == null) return const Ok(null);
    final rated = message.copyWith(
      metadata: rating == null
          ? message.metadata.remove<UserRating>()
          : message.metadata.put(rating),
    );
    await _cache.upsertMessages(conversationId, [rated]);
    final result = await guard(() => rater.rate(rated, rating));
    if (!result.isOk) {
      final latest = _cache.message(conversationId, messageId) ?? rated;
      await _cache.upsertMessages(conversationId, [
        latest.copyWith(metadata: message.metadata),
      ]);
    }
    return result;
  }

  ConversationManager? get _manager => switch (_provider) {
    final ConversationManager m
        when _provider.info.supports(ChatCapability.manageConversations) =>
      m,
    _ => null,
  };

  Conversation? _conversation(String id) =>
      _cache.conversations.where((c) => c.id == id).firstOrNull;

  @override
  Future<Result<void>> renameConversation(
    String conversationId,
    String title,
  ) async {
    final manager = _manager;
    final name = title.trim();
    if (manager == null || name.isEmpty) return const Ok(null);
    return guard(() async {
      await manager.renameConversation(conversationId, name);
      if (_conversation(conversationId) case final c?) {
        await _cache.upsertConversation(c.copyWith(title: name));
      }
    });
  }

  @override
  Future<Result<void>> setPinned(
    String conversationId, {
    required bool pinned,
  }) async {
    final manager = _manager;
    if (manager == null) return const Ok(null);
    return guard(() async {
      await manager.setPinned(conversationId, pinned: pinned);
      if (_conversation(conversationId) case final c?) {
        await _cache.upsertConversation(c.copyWith(isPinned: pinned));
      }
    });
  }

  @override
  Future<Result<void>> deleteConversation(String conversationId) async {
    final manager = _manager;
    if (manager == null) return const Ok(null);
    return guard(() async {
      await manager.deleteConversation(conversationId);
      _loaded.remove(conversationId);
      _cursors.remove(conversationId);
      await _cache.removeConversation(conversationId);
    });
  }

  @override
  Future<void> dispose() async {
    await _incoming.cancel();
    await _typingChanges.close();
  }
}
