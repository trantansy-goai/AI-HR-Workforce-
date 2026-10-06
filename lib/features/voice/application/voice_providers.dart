import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fake_voice_recorder.dart';
import '../domain/voice_recorder.dart';

final voiceRecorderProvider = Provider<VoiceRecorder>((ref) {
  final recorder = FakeVoiceRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

final voiceRecordingStateProvider = StreamProvider.autoDispose<Duration>((ref) {
  final recorder = ref.watch(voiceRecorderProvider);
  return recorder.durationStream;
});
