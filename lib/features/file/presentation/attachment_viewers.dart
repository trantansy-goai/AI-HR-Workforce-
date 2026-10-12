import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:video_player/video_player.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_feedback.dart';
import '../application/file_providers.dart';
import '../domain/attachment.dart';
import '../domain/mime_types.dart';
import 'file_type_style.dart';

/// Opens the full-screen viewer that fits [attachment]: image viewer, video
/// player, or file details with "open with another app". Audio plays inline
/// in the message, so it has no viewer.
Future<void> openAttachmentViewer(BuildContext context, Attachment attachment) {
  final Widget page = switch (attachment.kind) {
    AttachmentKind.image => ImageViewerPage(attachment: attachment),
    AttachmentKind.video => VideoViewerPage(attachment: attachment),
    _ => FileViewerPage(attachment: attachment),
  };
  return Navigator.of(
    context,
    rootNavigator: true,
  ).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => page));
}

/// Image from the device copy when available, else downloaded from its URL
/// (with the session's token for the app's own API).
class AttachmentImage extends ConsumerWidget {
  const AttachmentImage({
    super.key,
    required this.attachment,
    this.fit = BoxFit.cover,
  });

  final Attachment attachment;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget broken(BuildContext context, Object _, StackTrace? _) => Container(
      color: AppHrPalette.divider,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        color: AppHrPalette.inkMuted,
        size: 36,
      ),
    );
    final path = attachment.devicePath;
    if (path != null) {
      return Image.file(File(path), fit: fit, errorBuilder: broken);
    }
    if (attachment.remoteUrl == null) return broken(context, '', null);
    return switch (ref.watch(attachmentLocalPathProvider(attachment))) {
      AsyncData(:final value) => Image.file(
        File(value),
        fit: fit,
        errorBuilder: broken,
      ),
      AsyncError() => broken(context, '', null),
      _ => const ColoredBox(color: AppHrPalette.divider),
    };
  }
}

/// A player for [attachment] from its device copy (downloaded first when it
/// is remote); null when it has no file.
Future<VideoPlayerController?> videoControllerFor(
  WidgetRef ref,
  Attachment attachment,
) async {
  if (attachment.devicePath == null && attachment.remoteUrl == null) {
    return null;
  }
  final path = await ref.read(attachmentLocalPathProvider(attachment).future);
  return VideoPlayerController.file(File(path));
}

class _ViewerScaffold extends StatelessWidget {
  const _ViewerScaffold({required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: const Border(),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}

/// Full-screen image with pinch-to-zoom.
class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({super.key, required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return _ViewerScaffold(
      title: attachment.name,
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(
          child: Hero(
            tag: 'attachment-${attachment.id}',
            child: AttachmentImage(attachment: attachment, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

/// Full-screen video with play/pause and a seek bar.
class VideoViewerPage extends ConsumerStatefulWidget {
  const VideoViewerPage({super.key, required this.attachment});

  final Attachment attachment;

  @override
  ConsumerState<VideoViewerPage> createState() => _VideoViewerPageState();
}

class _VideoViewerPageState extends ConsumerState<VideoViewerPage> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final controller = await videoControllerFor(ref, widget.attachment);
      if (!mounted) {
        await controller?.dispose();
        return;
      }
      if (controller == null) {
        setState(() => _failed = true);
        return;
      }
      _controller = controller..addListener(_onTick);
      await controller.initialize();
      if (mounted) setState(() {});
      unawaited(controller.play());
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  void _toggle() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      if (c.value.position >= c.value.duration) c.seekTo(Duration.zero);
      c.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = _controller;
    final ready = c != null && c.value.isInitialized;

    return _ViewerScaffold(
      title: widget.attachment.name,
      body: _failed
          ? Center(
              child: Text(
                l10n.chatMediaUnavailable,
                style: const TextStyle(color: Colors.white70),
              ),
            )
          : !ready
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _toggle,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: c.value.aspectRatio,
                        child: VideoPlayer(c),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: c.value.isPlaying
                            ? l10n.chatPause
                            : l10n.chatPlay,
                        color: Colors.white,
                        icon: Icon(
                          c.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: _toggle,
                      ),
                      Text(
                        formatClock(c.value.position),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: VideoProgressIndicator(
                          c,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.lg,
                          ),
                          colors: const VideoProgressColors(
                            playedColor: Colors.white,
                            bufferedColor: Colors.white38,
                            backgroundColor: Colors.white12,
                          ),
                        ),
                      ),
                      Text(
                        formatClock(c.value.duration),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// File details with "open with another app" (system handler for the type).
class FileViewerPage extends ConsumerWidget {
  const FileViewerPage({super.key, required this.attachment});

  final Attachment attachment;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    OpenResult? result;
    try {
      final path = await ref.read(
        attachmentLocalPathProvider(attachment).future,
      );
      result = await OpenFilex.open(path);
    } on Object {
      result = null;
    }
    if (!context.mounted) return;
    if (result == null || result.type != ResultType.done) {
      context.showAppSnackBar(
        context.l10n.chatFileOpenFailed,
        type: AppSnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final style = FileTypeStyle.of(attachment);
    final size = attachment.sizeBytes == null
        ? null
        : MimeTypes.formatBytes(attachment.sizeBytes!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          attachment.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FileTypeIcon(attachment: attachment, size: 96),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  attachment.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppHrPalette.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  [?size, style.label].join(' · '),
                  style: const TextStyle(color: AppHrPalette.inkMuted),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: l10n.chatOpenWith,
                  icon: Icons.open_in_new,
                  onPressed: () => _open(context, ref),
                  expand: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `m:ss` (or `h:mm:ss`) for media positions and durations.
String formatClock(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '$m:${two(s)}';
}
