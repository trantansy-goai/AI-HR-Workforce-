import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/di/core_providers.dart';
import '../../../core/error/failure_messages.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../../../shared/widgets/responsive.dart';
import '../../../shared/widgets/state_views.dart';
import '../../auth/application/auth_providers.dart';
import '../../file/application/file_providers.dart';
import '../../file/domain/attachment.dart';
import '../../voice/application/voice_providers.dart';
import '../application/chat_providers.dart';
import '../application/conversation_controller.dart';
import '../domain/chat_provider.dart';
import '../domain/entities/conversation.dart';
import '../domain/entities/message.dart';
import '../domain/extensions/ai_extensions.dart';
import 'widgets/chat_composer.dart';
import 'widgets/file_type_sheet.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator.dart';

/// Open WebUI permission (`permissions.chat.file_upload`) for attachments.
const uploadPermission = 'chat.file_upload';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({
    super.key,
    required this.conversationId,
    this.initialMessage,
  });

  final String conversationId;

  /// Sent once when the page opens (e.g. a question typed on Hỏi HR).
  final String? initialMessage;

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  final _scrollController = ScrollController();

  /// Reads one answer at a time; created on first use.
  AudioPlayer? _speech;
  StreamSubscription<void>? _speechDone;
  String? _speakingId;

  ConversationController get _controller =>
      ref.read(conversationControllerProvider(widget.conversationId).notifier);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final initial = widget.initialMessage?.trim();
    if (initial != null && initial.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.send(initial);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    unawaited(_speechDone?.cancel());
    unawaited(_speech?.dispose());
    super.dispose();
  }

  Future<void> _rate(Message message, UserRating? rating) async {
    final result = await _controller.rate(message, rating);
    if (!result.isOk && mounted) {
      context.showAppSnackBar(
        context.l10n.chatActionFailed,
        type: AppSnackType.error,
      );
    }
  }

  /// Starts reading [message] aloud, or stops when it is already playing.
  Future<void> _toggleSpeech(Message message) async {
    final player = _speech ??= AudioPlayer();
    _speechDone ??= player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _speakingId = null);
    });
    final wasPlaying = _speakingId == message.id;
    await player.stop();
    setState(() => _speakingId = wasPlaying ? null : message.id);
    if (wasPlaying) return;
    try {
      final path = await ref
          .read(speechSynthesizerProvider)!
          .synthesize(_spokenText(message.content));
      // The user may have stopped or picked another answer meanwhile.
      if (!mounted || _speakingId != message.id) return;
      await player.play(DeviceFileSource(path));
    } on Object {
      if (!mounted) return;
      setState(() => _speakingId = null);
      context.showAppSnackBar(
        context.l10n.chatActionFailed,
        type: AppSnackType.error,
      );
    }
  }

  /// Markdown marks would be read out loud; keep the words only.
  static String _spokenText(String markdown) => markdown
      .replaceAll(RegExp(r'```[\s\S]*?```'), ' ')
      .replaceAllMapped(RegExp(r'\[([^\]]*)\]\([^)]*\)'), (m) => m[1]!)
      .replaceAll(
        RegExp(r'^\s{0,3}(#{1,6}|>|[-*+]|\d+\.)\s+', multiLine: true),
        '',
      )
      .replaceAll(RegExp(r'[*_`~|]'), '')
      .trim();

  void _onScroll() {
    // The list is reversed: the "end" is the oldest message.
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }

  /// Photos/videos through the system picker (Android Photo Picker, iOS
  /// PHPicker).
  Future<void> _attachMedia() async {
    final picked = await ref.read(attachmentPickerProvider).pickMedia();
    if (picked.isNotEmpty) _controller.addAttachments(picked);
  }

  /// File-type sheet, then the system file picker filtered to that type.
  /// Opens a cited document; web sources (absolute URLs) have no document.
  void _openSource(SourceReference source) {
    final uri = source.uri;
    if (uri != null && uri.startsWith('http')) return;
    context.push(AppRoutes.document(source.id));
  }

  Future<void> _attachFile() async {
    final choice = await showFileTypeSheet(context);
    if (choice == null) return;
    final picked = await ref
        .read(attachmentPickerProvider)
        .pickFiles(extensions: choice.extensions);
    if (picked.isNotEmpty) _controller.addAttachments(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = conversationControllerProvider(widget.conversationId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final info = controller.providerInfo;
    // Server-granted permission; the backend still enforces it on upload.
    final canAttach =
        info.supports(ChatCapability.attachments) &&
        (ref.watch(
              authControllerProvider.select(
                (s) => s.user?.allows(uploadPermission),
              ),
            ) ??
            true);
    final selfId = controller.self.id;
    final conversation = ref
        .watch(conversationsProvider)
        .value
        ?.where((c) => c.id == widget.conversationId)
        .firstOrNull;

    ref.listen(provider.select((s) => s.loadFailure), (_, failure) {
      if (failure != null && state.messages.isNotEmpty) {
        context.showAppSnackBar(
          failure.localizedMessage(l10n),
          type: AppSnackType.error,
        );
      }
    });

    final lastAiIndex = state.messages.lastIndexWhere(
      (m) => m.sender.isAutomated,
    );
    final canRegenerate =
        info.supports(ChatCapability.regenerate) &&
        !state.isGenerating &&
        lastAiIndex == state.messages.length - 1 &&
        state.messages.any((m) => m.sender.id == selfId);

    return Scaffold(
      appBar: AppBar(
        title: Text(conversation?.title ?? l10n.chatTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              info.displayName,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            Expanded(
              child: _buildMessages(
                context,
                state,
                selfId,
                conversation,
                canRegenerate,
                lastAiIndex,
              ),
            ),
            TypingIndicator(participants: state.typing),
            ChatComposer(
              voiceRecorder: ref.watch(voiceRecorderProvider),
              onSend: controller.send,
              onAttachMedia: canAttach ? _attachMedia : null,
              onAttachFile: canAttach ? _attachFile : null,
              onVoiceRecorded: canAttach ? controller.sendVoiceNote : null,
              onStop: info.supports(ChatCapability.stopGeneration)
                  ? controller.stopGeneration
                  : null,
              isGenerating: state.isGenerating,
              replyTo: state.replyTo == null
                  ? null
                  : ReplyReference.of(state.replyTo!),
              onCancelReply: () => controller.setReplyTo(null),
              attachments: state.pendingAttachments,
              onRemoveAttachment: controller.removeAttachment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(
    BuildContext context,
    ConversationState state,
    String selfId,
    Conversation? conversation,
    bool canRegenerate,
    int lastAiIndex,
  ) {
    final l10n = context.l10n;
    if (state.messages.isEmpty) {
      if (state.isInitialLoading) return const LoadingView();
      if (state.loadFailure != null) {
        return ErrorView(
          failure: state.loadFailure,
          onRetry: _controller.loadInitial,
        );
      }
      return EmptyView(
        title: l10n.chatEmptyMessages,
        // The /fail tip only works against the mock provider.
        message: ref.watch(appConfigProvider).useFakeBackend
            ? l10n.chatDemoHint
            : null,
        icon: Icons.chat_bubble_outline,
      );
    }

    final messages = state.messages;
    final isGroup = conversation?.kind == ConversationKind.group;
    final canTranscribe = ref.watch(speechTranscriberProvider) != null;
    final canSpeak = ref.watch(speechSynthesizerProvider) != null;
    final user = ref.watch(authControllerProvider).user;
    final canRate =
        ref
            .watch(chatRepositoryProvider)
            .providerInfo
            .supports(ChatCapability.rating) &&
        (user?.role == 'admin' ||
            (user?.allows('chat.rate_response') ?? false));
    final extra = state.isLoadingMore ? 1 : 0;

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: messages.length + extra,
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final messageIndex = messages.length - 1 - index;
        final message = messages[messageIndex];
        final isMine = message.sender.id == selfId;
        return MessageBubble(
          key: ValueKey(message.id),
          message: message,
          isMine: isMine,
          showSenderName: isGroup,
          onRetry: isMine ? () => _controller.retry(message) : null,
          onReply: () => _controller.setReplyTo(message),
          onRegenerate: canRegenerate && messageIndex == lastAiIndex
              ? _controller.regenerate
              : null,
          onOpenSource: _openSource,
          onRate: canRate && !isMine ? (r) => _rate(message, r) : null,
          onSpeak: canSpeak && !isMine ? () => _toggleSpeech(message) : null,
          isSpeaking: _speakingId == message.id,
          transcribing:
              canTranscribe &&
              message.isPending &&
              message.content.isEmpty &&
              message.attachments.any((a) => a.kind == AttachmentKind.audio),
        );
      },
    );
  }
}
