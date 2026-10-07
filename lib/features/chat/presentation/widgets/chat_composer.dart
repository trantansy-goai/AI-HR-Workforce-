import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../file/domain/attachment.dart';
import '../../../voice/data/fake_voice_recorder.dart';
import '../../../voice/domain/voice_recorder.dart';
import '../../domain/entities/message.dart';
import 'attachment_chip.dart';

/// Message input with send / stop, photo-video and file attach buttons,
/// voice recording and reply preview.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    this.onAttachMedia,
    this.onAttachFile,
    this.onVoiceRecorded,
    this.onStop,
    this.isGenerating = false,
    this.replyTo,
    this.onCancelReply,
    this.attachments = const [],
    this.onRemoveAttachment,
    this.voiceRecorder,
  });

  final ValueChanged<String> onSend;

  /// Opens the system photo/video picker.
  final VoidCallback? onAttachMedia;

  /// Opens the file-type sheet / document picker.
  final VoidCallback? onAttachFile;

  /// A finished voice note; the mic button is hidden when null.
  final void Function(String path, Duration duration)? onVoiceRecorded;
  final VoidCallback? onStop;
  final bool isGenerating;
  final ReplyReference? replyTo;
  final VoidCallback? onCancelReply;
  final List<Attachment> attachments;
  final ValueChanged<String>? onRemoveAttachment;
  final VoiceRecorder? voiceRecorder;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;
  late final VoiceRecorder _recorder;
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  StreamSubscription<Duration>? _durationSub;

  @override
  void initState() {
    super.initState();
    _recorder = widget.voiceRecorder ?? FakeVoiceRecorder();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });

    _durationSub = _recorder.durationStream.listen((duration) {
      if (mounted) setState(() => _recordDuration = duration);
    });
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _hasText || widget.attachments.isNotEmpty;

  void _submit() {
    if (!_canSend) return;
    widget.onSend(_controller.text.trim());
    _controller.clear();
  }

  Future<void> _toggleVoiceRecording() async {
    if (_isRecording) {
      final duration = _recordDuration;
      final audioPath = await _recorder.stop();
      if (!mounted) return;
      setState(() => _isRecording = false);
      if (audioPath != null) widget.onVoiceRecorded?.call(audioPath, duration);
      return;
    }

    final permission = await _recorder.requestPermission();
    if (!mounted) return;
    switch (permission) {
      case MicPermission.granted:
        try {
          await _recorder.start();
          if (mounted) setState(() => _isRecording = true);
        } catch (_) {
          if (mounted) _showSnack(context.l10n.chatMicPermissionDenied);
        }
      // Android can report a blocked mic as plain "denied" (seen on
      // Android 16), so always offer the settings shortcut.
      case MicPermission.denied || MicPermission.permanentlyDenied:
        await _askToOpenSettings();
    }
  }

  void _showSnack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  /// The system may not prompt again (e.g. denied twice on Android 11+), so
  /// point the user to the app settings instead of failing silently.
  Future<void> _askToOpenSettings() async {
    final l10n = context.l10n;
    final open = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.mic_off_outlined),
        title: Text(l10n.chatMicPermissionTitle),
        content: Text(l10n.chatMicPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.chatOpenSettings),
          ),
        ],
      ),
    );
    if (open ?? false) await _recorder.openPermissionSettings();
  }

  Future<void> _cancelVoiceRecording() async {
    await _recorder.cancel();
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isRecording)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mic, color: AppHrPalette.danger),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        l10n.chatRecording(_formatDuration(_recordDuration)),
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppHrPalette.danger,
                        ),
                        onPressed: _cancelVoiceRecording,
                        tooltip: l10n.chatCancelRecording,
                      ),
                    ],
                  ),
                ),
              if (widget.replyTo != null)
                _ReplyBanner(
                  reply: widget.replyTo!,
                  onCancel: widget.onCancelReply,
                ),
              if (widget.attachments.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final a in widget.attachments)
                          AttachmentChip(
                            attachment: a,
                            onRemove: widget.onRemoveAttachment == null
                                ? null
                                : () => widget.onRemoveAttachment!(a.id),
                          ),
                      ],
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.onAttachMedia != null)
                    IconButton(
                      tooltip: l10n.chatAttachMedia,
                      icon: const Icon(Icons.photo_library_outlined),
                      onPressed: _isRecording ? null : widget.onAttachMedia,
                    ),
                  if (widget.onAttachFile != null)
                    IconButton(
                      tooltip: l10n.chatAttachFile,
                      icon: const Icon(Icons.attach_file),
                      onPressed: _isRecording ? null : widget.onAttachFile,
                    ),
                  if (widget.onVoiceRecorded != null)
                    IconButton(
                      tooltip: _isRecording
                          ? l10n.chatStopRecording
                          : l10n.chatVoiceRecord,
                      icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic),
                      color: _isRecording ? AppHrPalette.danger : null,
                      onPressed: _toggleVoiceRecording,
                    ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: l10n.chatComposerHint,
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  if (widget.isGenerating && widget.onStop != null)
                    IconButton.filledTonal(
                      tooltip: l10n.chatStop,
                      icon: const Icon(Icons.stop),
                      onPressed: widget.onStop,
                    )
                  else
                    IconButton.filled(
                      tooltip: l10n.chatSend,
                      icon: const Icon(Icons.send),
                      onPressed: _canSend ? _submit : null,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReplyBanner extends StatelessWidget {
  const _ReplyBanner({required this.reply, this.onCancel});

  final ReplyReference reply;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.only(left: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chatReplyingTo(reply.senderName),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  reply.preview,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.chatCancelReply,
            icon: const Icon(Icons.close),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}
