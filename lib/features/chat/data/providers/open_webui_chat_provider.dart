import '../../../../core/error/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../shared/models/paged.dart';
import '../../../file/domain/attachment.dart';
import '../../../file/domain/mime_types.dart';
import '../../domain/chat_provider.dart';
import '../../domain/entities/agent_item.dart';
import '../../domain/entities/chat_event.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_metadata.dart';
import '../../domain/entities/participant.dart';
import '../../domain/extensions/ai_extensions.dart';
import '../sources/open_webui_chats_api.dart';
import '../sources/open_webui_client.dart';
import '../sources/open_webui_sse_parser.dart';
import 'ai_chat_providers.dart';

/// Provider for Open WebUI backed generative AI conversations.
///
/// Conversations started for an agent (see [AgentItem.newConversationId]) are
/// answered by the Open WebUI model with that id; the client falls back to
/// its default model when the server does not offer it.
///
/// With [chats], history lives on the server like on the website: the
/// conversation list and messages are read from `/api/v1/chats/*`, and every
/// finished answer is saved there (the chat is created on the first one).
/// Server chats keep their server id as conversation id; a conversation
/// started in the app keeps its `agent-…` id and is mapped to its server id.
class OpenWebUiChatProvider extends RemoteAIChatProvider
    implements ConversationManager, MessageRater {
  OpenWebUiChatProvider({
    required OpenWebUiClient client,
    super.assistant = const Participant(
      id: 'open-webui-assistant',
      displayName: 'GOAI Assistant',
      type: SenderType.ai,
    ),
    super.systemPrompt,
    super.options,
    super.conversations,
    super.ids,
    super.clock,
    this.agentModelIds = const {},
    this.chats,
    this.self = const Participant(
      id: 'anonymous',
      displayName: 'You',
      type: SenderType.user,
    ),
    this._logger = const SilentLogger(),
  }) : _client = client,
       _now = clock ?? DateTime.now,
       super(client: client);

  final OpenWebUiClient _client;
  final DateTime Function() _now;
  final AppLogger _logger;

  /// App agent id → Open WebUI model id, for agents the app names itself
  /// (e.g. the Hỏi HR assistant). Other agent ids are model ids already.
  final Map<String, String> agentModelIds;

  /// Server chat history; null keeps history on the device only.
  final OpenWebUiChatsApi? chats;

  /// The signed-in user, author of the user messages of server chats.
  final Participant self;

  static const _sseParser = OpenWebUiSseParser();

  /// Conversation id → server chat id, for conversations started here.
  final Map<String, String> _serverIds = {};

  /// Server chat id → conversation id (inverse of [_serverIds]).
  final Map<String, String> _conversationIds = {};

  /// Server chat id → model that answers in it.
  final Map<String, String> _models = {};

  /// Ids of messages already stored on the server.
  final Set<String> _saved = {};

  OpenWebUiClient get client => _client;

  /// Attachments are uploaded by `OpenWebUiFileUploader` and passed to the
  /// model as RAG files.
  @override
  ChatProviderInfo get info => const ChatProviderInfo(
    id: 'open-webui',
    displayName: 'GO AI Workforce',
    capabilities: {
      ChatCapability.streaming,
      ChatCapability.stopGeneration,
      ChatCapability.regenerate,
      ChatCapability.citations,
      ChatCapability.attachments,
      ChatCapability.rating,
      ChatCapability.manageConversations,
    },
  );

  @override
  String? modelIdFor(String conversationId) {
    final agentId = AgentItem.agentIdOf(conversationId);
    if (agentId != null) return agentModelIds[agentId] ?? agentId;
    return _models[_serverIdOf(conversationId)];
  }

  /// The server chat behind [conversationId], null when not created yet
  /// (before the first answer is saved there is nothing to change on the
  /// server).
  String? _serverIdOf(String conversationId) =>
      _serverIds[conversationId] ??
      (AgentItem.agentIdOf(conversationId) == null ? conversationId : null);

  // ---------------------------------------------------------------------------
  // Reading history

  @override
  Future<List<Conversation>> fetchConversations() async {
    final api = chats;
    if (api == null) return super.fetchConversations();
    final summaries = await api.listChats();
    return [for (final chat in summaries) _conversationOf(chat)];
  }

  Conversation _conversationOf(OpenWebUiChatSummary chat) {
    if (chat.modelId case final model?) _models[chat.id] = model;
    return Conversation(
      id: _conversationIds[chat.id] ?? chat.id,
      title: chat.title,
      kind: ConversationKind.assistant,
      participants: _participants(chat.modelId),
      updatedAt: chat.updatedAt,
      isPinned: chat.pinned,
    );
  }

  /// The user and, when known, the model; agent lists filter on the model.
  List<Participant> _participants(String? modelId) => [
    self,
    if (modelId != null)
      Participant(id: modelId, displayName: modelId, type: SenderType.ai),
  ];

  @override
  Future<Paged<Message>> fetchMessages(
    String conversationId, {
    String? before,
    int limit = 30,
  }) async {
    final api = chats;
    final serverId = _serverIdOf(conversationId);
    // A chat is one document: the first page holds all of it.
    if (api == null || serverId == null || before != null) {
      return const Paged.empty();
    }
    final chat = await api.getChat(serverId);
    if (chat.modelId case final model?) _models[serverId] = model;
    final messages = [
      for (final message in chat.messages)
        ?_fromServer(conversationId, message),
    ];
    _saved.addAll(messages.map((m) => m.id));
    return Paged(items: messages);
  }

  Message? _fromServer(String conversationId, Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final role = json['role'];
    if (id == null || (role != 'user' && role != 'assistant')) return null;
    final isAnswer = role == 'assistant';
    final content = json['content']?.toString() ?? '';
    final attachments = isAnswer
        ? const <Attachment>[]
        : _attachmentsOf(json['files']);
    final error = json['error'];
    return Message(
      id: id,
      conversationId: conversationId,
      sender: isAnswer ? assistant : self,
      createdAt: switch (json['timestamp']) {
        final num seconds => DateTime.fromMillisecondsSinceEpoch(
          (seconds * 1000).round(),
        ),
        _ => DateTime.fromMillisecondsSinceEpoch(0),
      },
      type: content.isEmpty && attachments.isNotEmpty
          ? _typeOf(attachments.first)
          : MessageType.text,
      content: content,
      attachments: attachments,
      status: isAnswer && error != null && error != false && content.isEmpty
          ? MessageStatus.failed
          : MessageStatus.sent,
      metadata: isAnswer
          ? _answerMetadata(json)
          : const MessageMetadata.empty(),
    );
  }

  MessageMetadata _answerMetadata(Map<String, dynamic> json) {
    final model = json['model']?.toString() ?? '';
    final usage = json['usage'] is Map
        ? json['usage'] as Map
        : const <String, Object?>{};
    var metadata = MessageMetadata.of([
      AiGenerationInfo(
        model: ModelInfo(
          id: model,
          displayName: json['modelName']?.toString() ?? model,
        ),
        finishReason: json['error'] != null && json['error'] != false
            ? FinishReasons.error
            : FinishReasons.stop,
        promptTokens: (usage['prompt_tokens'] as num?)?.toInt(),
        completionTokens: (usage['completion_tokens'] as num?)?.toInt(),
      ),
    ]);
    final sources = _sseParser.parseSources(json['sources']);
    if (sources.isNotEmpty) metadata = metadata.put(Citations(sources));
    // The website's 👍/👎: `annotation.rating` = 1 / -1.
    if (json['annotation'] case {'rating': final num rating}
        when rating == 1 || rating == -1) {
      metadata = metadata.put(UserRating(rating.toInt()));
    }
    return metadata;
  }

  /// Website/app file entries: `{"type": "file", "id", "name", "size",
  /// "file": {"meta": {"content_type"}}}`.
  List<Attachment> _attachmentsOf(Object? files) {
    final api = chats;
    if (api == null || files is! List) return const [];
    return [
      for (final file in files.whereType<Map<String, dynamic>>())
        if (_fileId(file) case final id?) _attachmentOf(api, id, file),
    ];
  }

  static String? _fileId(Map<String, dynamic> file) =>
      switch (file['id'] ?? (file['file'] as Map?)?['id']) {
        final String id when id.isNotEmpty => id,
        _ => null,
      };

  Attachment _attachmentOf(
    OpenWebUiChatsApi api,
    String id,
    Map<String, dynamic> file,
  ) {
    final inner = file['file'] is Map
        ? file['file'] as Map
        : const <String, Object?>{};
    final meta = inner['meta'] is Map
        ? inner['meta'] as Map
        : const <String, Object?>{};
    final name = (file['name'] ?? meta['name'] ?? inner['filename'] ?? id)
        .toString();
    final mimeType =
        (file['content_type'] ?? meta['content_type'])?.toString() ??
        MimeTypes.fromFileName(name);
    return Attachment(
      id: id,
      name: name,
      mimeType: mimeType,
      kind: MimeTypes.kindOf(mimeType),
      source: RemoteAttachmentSource(
        url: api.fileContentUrl(id),
        storageKey: id,
      ),
      sizeBytes: ((file['size'] ?? meta['size']) as num?)?.toInt(),
      uploadStatus: UploadStatus.uploaded,
    );
  }

  static MessageType _typeOf(Attachment attachment) =>
      switch (attachment.kind) {
        AttachmentKind.image => MessageType.image,
        AttachmentKind.video => MessageType.video,
        AttachmentKind.audio => MessageType.audio,
        AttachmentKind.document || AttachmentKind.other => MessageType.file,
      };

  // ---------------------------------------------------------------------------
  // Conversation management & ratings

  @override
  Future<void> renameConversation(String conversationId, String title) async {
    final serverId = _serverIdOf(conversationId);
    if (serverId == null) return;
    await chats?.updateChat(serverId, {'title': title});
  }

  @override
  Future<void> setPinned(String conversationId, {required bool pinned}) async {
    final serverId = _serverIdOf(conversationId);
    if (serverId == null) return;
    await chats?.setPinned(serverId, pinned: pinned);
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final serverId = _serverIdOf(conversationId);
    if (serverId == null) return;
    await chats?.deleteChat(serverId);
    _serverIds.remove(conversationId);
    _conversationIds.remove(serverId);
    _models.remove(serverId);
  }

  /// Like the website: a feedback record (for the admin's evaluations) plus
  /// `annotation.rating` / `feedbackId` on the stored message, so the
  /// rating shows again when the chat is reopened anywhere.
  @override
  Future<void> rate(Message message, UserRating? rating) async {
    final api = chats;
    final serverId = _serverIdOf(message.conversationId);
    if (api == null || serverId == null) {
      throw const NotFoundFailure('The chat is not saved yet');
    }
    final (message: stored, :currentId) = await api.storedMessage(
      serverId,
      message.id,
    );
    final annotation = {...?(stored['annotation'] as Map<String, dynamic>?)}
      ..remove('rating');
    var feedbackId = stored['feedbackId']?.toString();
    final modelId = stored['model']?.toString();
    if (rating == null) {
      if (feedbackId != null) await api.deleteFeedback(feedbackId);
      feedbackId = null;
    } else {
      annotation['rating'] = rating.value;
      feedbackId = await api.saveFeedback({
        'type': 'rating',
        'data': {'rating': rating.value, 'model_id': ?modelId},
        'meta': {
          'model_id': ?modelId,
          'message_id': stored['id'],
          'chat_id': serverId,
        },
      }, feedbackId: feedbackId);
    }
    await api.updateChat(serverId, {
      'history': {
        'messages': {
          stored['id'].toString(): {
            ...stored,
            'annotation': annotation,
            'feedbackId': feedbackId,
          },
        },
        'currentId': currentId,
      },
    });
  }

  // ---------------------------------------------------------------------------
  // Saving history

  @override
  Stream<ChatEvent> send(OutgoingMessage message) => _saving(
    message.conversationId,
    [...message.history, message.toMessage()],
    super.send(message),
  );

  @override
  Stream<ChatEvent> regenerate(
    String conversationId, {
    required List<Message> history,
  }) {
    // The new answer is a sibling of the old one: both reply to the last
    // user message (a branch, as on the website).
    final asked = [...history];
    while (asked.isNotEmpty && asked.last.sender.id == assistant.id) {
      asked.removeLast();
    }
    return _saving(
      conversationId,
      asked,
      super.regenerate(conversationId, history: history),
    );
  }

  /// Forwards [events], then saves [asked] plus the finished answer.
  Stream<ChatEvent> _saving(
    String conversationId,
    List<Message> asked,
    Stream<ChatEvent> events,
  ) async* {
    Message? answer;
    await for (final event in events) {
      if (event case MessageUpserted(:final message)
          when message.sender.id == assistant.id && !message.isStreaming) {
        answer = message;
      }
      yield event;
    }
    if (chats == null || answer == null || answer.isFailed) return;
    final created = await _save(conversationId, [...asked, answer]);
    if (created != null) yield ConversationUpserted(created);
  }

  /// Stores the unsaved messages of [branch] (oldest first, ending with the
  /// answer). Creates the server chat on first save and returns it as a
  /// conversation; never throws, since the answer is already shown.
  Future<Conversation?> _save(
    String conversationId,
    List<Message> branch,
  ) async {
    final api = chats!;
    final messages = [
      for (final m in branch)
        if (m.sender.type != SenderType.system && !m.isFailed) m,
    ];
    final answer = messages.last;
    final modelId = switch (answer.metadata.get<AiGenerationInfo>()?.model.id) {
      final id? when id.isNotEmpty => id,
      _ => modelIdFor(conversationId),
    };
    final unsaved = <String, Map<String, Object?>>{
      for (var i = 0; i < messages.length; i++)
        if (!_saved.contains(messages[i].id))
          messages[i].id: _toServer(
            messages[i],
            parentId: i == 0 ? null : messages[i - 1].id,
            modelId: modelId,
          ),
    };
    final history = {'messages': unsaved, 'currentId': answer.id};

    try {
      var serverId = _serverIdOf(conversationId);
      Conversation? created;
      if (serverId == null) {
        final title = _titleOf(messages);
        serverId = await api.createChat({
          'title': title,
          'models': [?modelId],
          'history': history,
          'messages': unsaved.values.toList(),
          'timestamp': _now().millisecondsSinceEpoch,
        });
        _serverIds[conversationId] = serverId;
        _conversationIds[serverId] = conversationId;
        final generated = await _generateTitle(serverId, modelId, messages);
        created = Conversation(
          id: conversationId,
          title: generated ?? title,
          kind: ConversationKind.assistant,
          participants: _participants(modelId),
          updatedAt: answer.createdAt,
          lastMessage: answer,
        );
      } else {
        await api.updateChat(serverId, {'history': history});
      }
      if (modelId != null) _models[serverId] = modelId;
      _saved.addAll(unsaved.keys);
      return created;
    } on Object catch (error) {
      _logger.warning('Saving chat history failed', tag: 'chat', error: error);
      return null;
    }
  }

  /// Asks the server for a title like the website does and stores it.
  /// Null (keep the first question) when the admin disabled it or it fails.
  Future<String?> _generateTitle(
    String serverId,
    String? modelId,
    List<Message> messages,
  ) async {
    final api = chats!;
    if (modelId == null) return null;
    try {
      final title = await api.generateTitle(
        chatId: serverId,
        modelId: modelId,
        messages: [
          for (final m in messages)
            {
              'role': m.sender.id == assistant.id ? 'assistant' : 'user',
              'content': m.content,
            },
        ],
      );
      if (title == null) return null;
      await api.updateChat(serverId, {'title': title});
      return title;
    } on Object catch (error) {
      _logger.warning(
        'Chat title generation failed',
        tag: 'chat',
        error: error,
      );
      return null;
    }
  }

  /// Message in the website's format.
  Map<String, Object?> _toServer(
    Message message, {
    required String? parentId,
    required String? modelId,
  }) {
    final base = <String, Object?>{
      'id': message.id,
      'parentId': parentId,
      'childrenIds': const <String>[],
      'content': message.content,
      'timestamp': message.createdAt.millisecondsSinceEpoch ~/ 1000,
    };
    if (message.sender.id != assistant.id) {
      return {
        ...base,
        'role': 'user',
        'models': [?modelId],
        if (_filesOf(message) case final files when files.isNotEmpty)
          'files': files,
      };
    }
    final info = message.metadata.get<AiGenerationInfo>();
    final sources = message.metadata.get<Citations>()?.sources ?? const [];
    return {
      ...base,
      'role': 'assistant',
      'model': ?modelId,
      if (info != null && info.model.displayName.isNotEmpty)
        'modelName': info.model.displayName,
      'modelIdx': 0,
      'done': true,
      if (sources.isNotEmpty)
        'sources': [
          for (final s in sources)
            {
              'source': {'id': s.id, 'name': s.title, 'url': ?s.uri},
              'document': [?s.snippet],
              'metadata': [
                {'name': s.title, 'source': s.uri ?? s.title},
              ],
            },
        ],
      if (info?.promptTokens != null || info?.completionTokens != null)
        'usage': {
          'prompt_tokens': ?info?.promptTokens,
          'completion_tokens': ?info?.completionTokens,
        },
    };
  }

  static List<Map<String, Object?>> _filesOf(Message message) => [
    for (final a in message.attachments)
      if (a.source case RemoteAttachmentSource(:final storageKey?))
        {
          'type': 'file',
          'id': storageKey,
          'name': a.name,
          'size': ?a.sizeBytes,
          'url': '/api/v1/files/$storageKey',
          'status': 'uploaded',
          'content_type': a.mimeType,
          'file': {
            'id': storageKey,
            'filename': a.name,
            'meta': {
              'name': a.name,
              'content_type': a.mimeType,
              'size': ?a.sizeBytes,
            },
          },
        },
  ];

  /// First question, shortened; the website renames chats with a model, the
  /// app does not spend a model call on it.
  static String _titleOf(List<Message> messages) {
    for (final m in messages) {
      final text = m.content.trim().replaceAll(RegExp(r'\s+'), ' ');
      final title = text.isNotEmpty
          ? text
          : m.attachments.map((a) => a.name).join(', ');
      if (title.isEmpty) continue;
      return title.length <= 60 ? title : '${title.substring(0, 59)}…';
    }
    return 'New Chat';
  }
}
