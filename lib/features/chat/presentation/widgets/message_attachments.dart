import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../file/domain/attachment.dart';
import '../../../file/domain/mime_types.dart';
import '../../../file/presentation/attachment_viewers.dart';
import '../../../file/presentation/file_type_style.dart';

/// Renders a message's attachments by kind:
/// image → the picture, video → thumbnail + play, audio → inline player,
/// anything else → file card (type icon, name, size). Tapping opens the
/// matching full-screen viewer.
class MessageAttachments extends StatelessWidget {
  const MessageAttachments({
    super.key,
    required this.attachments,
    required this.foreground,
  });

  final List<Attachment> attachments;

  /// Text/icon color on the bubble background.
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final a in attachments)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _UploadOverlay(
              attachment: a,
              child: switch (a.kind) {
                AttachmentKind.image => _ImageTile(attachment: a),
                AttachmentKind.video => _VideoTile(attachment: a),
                AttachmentKind.audio => AudioAttachmentPlayer(
                  attachment: a,
                  color: foreground,
                ),
                _ => _FileTile(attachment: a, color: foreground),
              },
            ),
          ),
      ],
    );
  }
}

/// Thin progress bar under an attachment while it uploads.
class _UploadOverlay extends StatelessWidget {
  const _UploadOverlay({required this.attachment, required this.child});

  final Attachment attachment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (attachment.uploadStatus != UploadStatus.uploading) return child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(value: attachment.uploadProgress),
      ],
    );
  }
}

const _mediaRadius = BorderRadius.all(Radius.circular(12));

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      button: true,
      label: attachment.name,
      child: GestureDetector(
        onTap: () => openAttachmentViewer(context, attachment),
        child: ClipRRect(
          borderRadius: _mediaRadius,
          // Fixed square frame; the picture is center-cropped to fill it.
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'attachment-${attachment.id}',
              child: AttachmentImage(attachment: attachment),
            ),
          ),
        ),
      ),
    );
  }
}

/// First frame of the video with a play button; opens the video viewer.
class _VideoTile extends StatefulWidget {
  const _VideoTile({required this.attachment});

  final Attachment attachment;

  @override
  State<_VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<_VideoTile> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final controller = videoControllerFor(widget.attachment);
    _controller = controller;
    controller
        ?.initialize()
        .then((_) {
          if (mounted) setState(() {});
        })
        .catchError((Object _) {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final ready = c != null && c.value.isInitialized;
    final duration =
        widget.attachment.media?.duration ?? (ready ? c.value.duration : null);

    return Semantics(
      button: true,
      label: '${context.l10n.chatPlay} ${widget.attachment.name}',
      child: GestureDetector(
        onTap: () => openAttachmentViewer(context, widget.attachment),
        child: ClipRRect(
          borderRadius: _mediaRadius,
          // Same square frame as images; the first frame is center-cropped.
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (ready)
                  FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: c.value.size.width,
                      height: c.value.size.height,
                      child: VideoPlayer(c),
                    ),
                  )
                else
                  const ColoredBox(color: Color(0xFF1F2733)),
                Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                if (duration != null && duration > Duration.zero)
                  Positioned(
                    right: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs + 2,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        formatClock(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile({required this.attachment, required this.color});

  final Attachment attachment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final style = FileTypeStyle.of(attachment);
    final size = attachment.sizeBytes == null
        ? null
        : MimeTypes.formatBytes(attachment.sizeBytes!);
    final failed = attachment.uploadStatus == UploadStatus.failed;

    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: _mediaRadius,
        side: BorderSide(
          color: failed ? AppHrPalette.danger : AppHrPalette.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openAttachmentViewer(context, attachment),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              FileTypeIcon(attachment: attachment),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppHrPalette.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      [?size, style.label].join(' · '),
                      style: const TextStyle(
                        color: AppHrPalette.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline audio: play/pause, duration (or position) and a progress bar.
class AudioAttachmentPlayer extends StatefulWidget {
  const AudioAttachmentPlayer({
    super.key,
    required this.attachment,
    required this.color,
  });

  final Attachment attachment;
  final Color color;

  @override
  State<AudioAttachmentPlayer> createState() => _AudioAttachmentPlayerState();
}

class _AudioAttachmentPlayerState extends State<AudioAttachmentPlayer> {
  AudioPlayer? _player;
  final _subs = <StreamSubscription<Object?>>[];
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _duration = widget.attachment.media?.duration;
  }

  Source? get _source {
    final path = widget.attachment.devicePath;
    if (path != null) return DeviceFileSource(path);
    final url = widget.attachment.remoteUrl;
    return url == null ? null : UrlSource(url);
  }

  /// Created on first play so lists of messages don't spin up players.
  AudioPlayer _ensurePlayer() {
    final existing = _player;
    if (existing != null) return existing;
    final player = AudioPlayer();
    _subs
      ..add(
        player.onPlayerStateChanged.listen((s) {
          if (mounted) setState(() => _state = s);
        }),
      )
      ..add(
        player.onPositionChanged.listen((p) {
          if (mounted) setState(() => _position = p);
        }),
      )
      ..add(
        player.onDurationChanged.listen((d) {
          if (mounted && d > Duration.zero) setState(() => _duration = d);
        }),
      )
      ..add(
        player.onPlayerComplete.listen((_) {
          if (mounted) setState(() => _position = Duration.zero);
        }),
      );
    return _player = player;
  }

  Future<void> _toggle() async {
    final player = _ensurePlayer();
    try {
      if (_state == PlayerState.playing) {
        await player.pause();
      } else if (_state == PlayerState.paused) {
        await player.resume();
      } else {
        final source = _source;
        if (source == null) throw StateError('No audio source');
        await player.play(source);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.chatMediaUnavailable)),
      );
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final playing = _state == PlayerState.playing;
    final duration = _duration;
    final active =
        _state == PlayerState.playing || _state == PlayerState.paused;
    final progress = duration == null || duration == Duration.zero
        ? 0.0
        : (_position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: playing ? l10n.chatPause : l10n.chatPlay,
            onPressed: _toggle,
            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  active
                      ? formatClock(_position)
                      : duration == null
                      ? l10n.chatVoiceNote
                      : formatClock(duration),
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    color: widget.color,
                    backgroundColor: widget.color.withValues(alpha: 0.25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
