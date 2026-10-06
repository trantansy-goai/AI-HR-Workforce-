import 'dart:async';

enum RecordingStatus { idle, recording, stopped, error }

class VoiceRecordingState {
  const VoiceRecordingState({
    required this.status,
    this.path,
    this.duration = Duration.zero,
    this.errorMessage,
  });

  final RecordingStatus status;
  final String? path;
  final Duration duration;
  final String? errorMessage;

  bool get isRecording => status == RecordingStatus.recording;
  bool get isStopped => status == RecordingStatus.stopped;

  VoiceRecordingState copyWith({
    RecordingStatus? status,
    String? path,
    Duration? duration,
    String? errorMessage,
  }) {
    return VoiceRecordingState(
      status: status ?? this.status,
      path: path ?? this.path,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Abstract contract for voice recording across platforms.
abstract interface class VoiceRecorder {
  Future<bool> hasPermission();
  Future<void> start({String? customPath});
  Future<String?> stop();
  Future<void> cancel();

  Stream<Duration> get durationStream;
  RecordingStatus get status;

  void dispose();
}
