import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/participant.dart';
import '../../domain/extensions/ai_extensions.dart';
import 'message_attachments.dart';

/// Renders one message. Pure widget: all actions are callbacks so it works
/// with any state management and is easy to test.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.showSenderName = false,
    this.onRetry,
    this.onReply,
    this.onRegenerate,
    this.onOpenSource,
    this.transcribing = false,
    this.onRate,
    this.onSpeak,
    this.isSpeaking = false,
  });

  final Message message;
  final bool isMine;
  final bool showSenderName;
  final VoidCallback? onRetry;
  final VoidCallback? onReply;

  /// Shown under the message when non-null (e.g. last AI answer).
  final VoidCallback? onRegenerate;

  /// Makes citation chips tappable (e.g. to open the cited document).
  final ValueChanged<SourceReference>? onOpenSource;

  /// The voice note's text is being produced; it replaces this hint in the
  /// same bubble.
  final bool transcribing;

  /// Shows 👍/👎 when non-null; called with the new rating (null clears).
  final ValueChanged<UserRating?>? onRate;

  /// Shows a "read aloud" button when non-null; it toggles reading.
  final VoidCallback? onSpeak;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    if (message.sender.type == SenderType.system ||
        message.type == MessageType.system) {
      return _SystemMessage(text: message.content);
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final background = isMine ? scheme.primary : scheme.surfaceContainerHigh;
    final foreground = isMine ? scheme.onPrimary : scheme.onSurface;
    final citations = message.metadata.get<Citations>();
    final maxWidth = MediaQuery.sizeOf(context).width * 2 / 3;

    final bubble = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: message.isFailed ? scheme.errorContainer : background,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.lg),
          topRight: const Radius.circular(AppRadius.lg),
          bottomLeft: Radius.circular(isMine ? AppRadius.lg : AppRadius.xs),
          bottomRight: Radius.circular(isMine ? AppRadius.xs : AppRadius.lg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.replyTo != null)
            _ReplyQuote(reply: message.replyTo!, color: foreground),
          if (message.attachments.isNotEmpty)
            MessageAttachments(
              attachments: message.attachments,
              foreground: message.isFailed
                  ? scheme.onErrorContainer
                  : foreground,
            ),
          if (transcribing && message.content.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Text(
                l10n.chatTranscribing,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: foreground.withValues(alpha: 0.75),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (message.content.isNotEmpty || message.isStreaming)
            Text.rich(
              TextSpan(
                text: message.content,
                children: [if (message.isStreaming) const TextSpan(text: ' ▍')],
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: message.isFailed ? scheme.onErrorContainer : foreground,
              ),
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs + 1,
      ),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (showSenderName && !isMine)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.xxs,
              ),
              child: Text(
                message.sender.displayName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ConstrainedBox(
            // A message is at most 2/3 of the screen; messages with
            // attachments use that full width so media/file cards line up.
            constraints: message.attachments.isEmpty
                ? BoxConstraints(maxWidth: maxWidth)
                : BoxConstraints.tightFor(width: maxWidth),
            child: GestureDetector(
              onTap: message.isFailed ? onRetry : null,
              onLongPress: onReply,
              child: bubble,
            ),
          ),
          if (citations != null && citations.sources.isNotEmpty)
            _Citations(citations: citations, onOpen: onOpenSource),
          _Footer(
            message: message,
            isMine: isMine,
            failedLabel: l10n.chatFailed,
            onRegenerate: onRegenerate,
            regenerateLabel: l10n.chatRegenerate,
          ),
          if (!isMine &&
              !message.isStreaming &&
              !message.isFailed &&
              message.content.isNotEmpty &&
              (onRate != null || onSpeak != null))
            _AnswerActions(
              rating: message.metadata.get<UserRating>(),
              onRate: onRate,
              onSpeak: onSpeak,
              isSpeaking: isSpeaking,
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.message,
    required this.isMine,
    required this.failedLabel,
    required this.regenerateLabel,
    this.onRegenerate,
  });

  final Message message;
  final bool isMine;
  final String failedLabel;
  final String regenerateLabel;
  final VoidCallback? onRegenerate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final time = TimeOfDay.fromDateTime(message.createdAt).format(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.isFailed)
            Text(
              failedLabel,
              style: style?.copyWith(color: theme.colorScheme.error),
            )
          else
            Text(time, style: style),
          if (isMine && !message.isFailed) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(
              _statusIcon(message.status),
              size: 14,
              color: message.status == MessageStatus.read
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              semanticLabel: message.status.name,
            ),
          ],
          if (onRegenerate != null && !message.isStreaming) ...[
            const SizedBox(width: AppSpacing.sm),
            InkWell(
              onTap: onRegenerate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 14, color: style?.color),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(regenerateLabel, style: style),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _statusIcon(MessageStatus status) => switch (status) {
    MessageStatus.sending => Icons.schedule,
    MessageStatus.sent || MessageStatus.streaming => Icons.check,
    MessageStatus.delivered || MessageStatus.read => Icons.done_all,
    MessageStatus.failed => Icons.error_outline,
  };
}

/// 👍 / 👎 (tap again to clear) and read aloud, under an answer.
class _AnswerActions extends StatelessWidget {
  const _AnswerActions({
    required this.rating,
    required this.onRate,
    required this.onSpeak,
    required this.isSpeaking,
  });

  final UserRating? rating;
  final ValueChanged<UserRating?>? onRate;
  final VoidCallback? onSpeak;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    Widget action({
      required IconData icon,
      required String tooltip,
      required VoidCallback onPressed,
      bool selected = false,
    }) => IconButton(
      icon: Icon(icon, size: 18),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      isSelected: selected,
      color: selected ? scheme.primary : scheme.onSurfaceVariant,
      onPressed: onPressed,
    );

    final rate = onRate;
    final speak = onSpeak;
    final liked = rating?.isPositive == true;
    final disliked = rating != null && !rating!.isPositive;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rate != null) ...[
          action(
            icon: liked ? Icons.thumb_up : Icons.thumb_up_outlined,
            tooltip: l10n.chatRateGood,
            selected: liked,
            onPressed: () => rate(liked ? null : const UserRating(1)),
          ),
          action(
            icon: disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
            tooltip: l10n.chatRateBad,
            selected: disliked,
            onPressed: () => rate(disliked ? null : const UserRating(-1)),
          ),
        ],
        if (speak != null)
          action(
            icon: isSpeaking
                ? Icons.stop_circle_outlined
                : Icons.volume_up_outlined,
            tooltip: isSpeaking ? l10n.chatStopReading : l10n.chatReadAloud,
            selected: isSpeaking,
            onPressed: speak,
          ),
      ],
    );
  }
}

class _ReplyQuote extends StatelessWidget {
  const _ReplyQuote({required this.reply, required this.color});

  final ReplyReference reply;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: color.withValues(alpha: 0.6), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.senderName,
            style: textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            reply.preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _Citations extends StatelessWidget {
  const _Citations({required this.citations, this.onOpen});

  final Citations citations;
  final ValueChanged<SourceReference>? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(context.l10n.chatSources, style: theme.textTheme.labelSmall),
          for (final source in citations.sources)
            ActionChip(
              visualDensity: VisualDensity.compact,
              avatar: const Icon(Icons.link, size: 14),
              label: Text(source.title, style: theme.textTheme.labelSmall),
              onPressed: onOpen == null ? null : () => onOpen!(source),
            ),
        ],
      ),
    );
  }
}

class _SystemMessage extends StatelessWidget {
  const _SystemMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
