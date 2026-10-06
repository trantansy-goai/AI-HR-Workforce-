import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../domain/voice_recorder.dart';

/// Production native implementation of [VoiceRecorder] using [AudioRecorder].
class NativeVoiceRecorder implements VoiceRecorder {
  NativeVoiceRecorder({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;

  RecordingStatus _status = RecordingStatus.idle;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final _durationController = StreamController<Duration>.broadcast();
  String? _currentRecordingPath;

  @override
  RecordingStatus get status => _status;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Future<bool> hasPermission() async {
    try {
      return await _recorder.hasPermission();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> start({String? customPath}) async {
    final granted = await hasPermission();
    if (!granted) {
      _status = RecordingStatus.error;
      throw Exception('Microphone permission denied');
    }

    try {
      final outputPath = customPath ?? await _generateTempPath();
      _currentRecordingPath = outputPath;

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: outputPath,
      );

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
    } catch (e) {
      _status = RecordingStatus.error;
      _cleanupFile(_currentRecordingPath);
      _currentRecordingPath = null;
      rethrow;
    }
  }

  @override
  Future<String?> stop() async {
    _timer?.cancel();
    _timer = null;

    if (_status != RecordingStatus.recording) {
      return null;
    }

    try {
      final path = await _recorder.stop();
      _status = RecordingStatus.stopped;
      final finalPath = path ?? _currentRecordingPath;
      _currentRecordingPath = null;
      return finalPath;
    } catch (e) {
      _status = RecordingStatus.error;
      _cleanupFile(_currentRecordingPath);
      _currentRecordingPath = null;
      rethrow;
    }
  }

  @override
  Future<void> cancel() async {
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;
    _durationController.add(_elapsed);

    try {
      await _recorder.cancel();
    } catch (_) {
      // Best-effort platform cancel
    } finally {
      _cleanupFile(_currentRecordingPath);
      _currentRecordingPath = null;
      _status = RecordingStatus.idle;
    }
  }

  Future<String> _generateTempPath() async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${tempDir.path}/voice_recording_$timestamp.m4a';
  }

  void _cleanupFile(String? path) {
    if (path == null) return;
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {
      // Ignore cleanup error
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationController.close();
    _cleanupFile(_currentRecordingPath);
    _recorder.dispose();
  }
}
