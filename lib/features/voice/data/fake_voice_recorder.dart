import 'dart:async';

import '../domain/voice_recorder.dart';

/// In-memory & test implementation of [VoiceRecorder].
class FakeVoiceRecorder implements VoiceRecorder {
  FakeVoiceRecorder({
    this.grantPermission = true,
    this.simulatedOutputPath = '/tmp/fake_voice_recording.m4a',
  });

  final bool grantPermission;
  final String simulatedOutputPath;

  RecordingStatus _status = RecordingStatus.idle;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final _durationController = StreamController<Duration>.broadcast();

  @override
  RecordingStatus get status => _status;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Future<bool> hasPermission() async => grantPermission;

  @override
  Future<void> start({String? customPath}) async {
    if (!grantPermission) {
      _status = RecordingStatus.error;
      throw Exception('Microphone permission denied');
    }

    _status = RecordingStatus.recording;
    _elapsed = Duration.zero;
    _durationController.add(_elapsed);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_status == RecordingStatus.recording) {
        _elapsed += const Duration(seconds: 1);
        _durationController.add(_elapsed);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Future<String?> stop() async {
    _timer?.cancel();
    _timer = null;
    if (_status == RecordingStatus.recording) {
      _status = RecordingStatus.stopped;
      return customOutputPath ?? simulatedOutputPath;
    }
    return null;
  }

  String? customOutputPath;

  @override
  Future<void> cancel() async {
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;
    _status = RecordingStatus.idle;
    _durationController.add(_elapsed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationController.close();
  }
}
