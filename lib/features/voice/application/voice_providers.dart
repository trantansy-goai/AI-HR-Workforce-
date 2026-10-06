import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/fake_voice_recorder.dart';
import '../data/native_voice_recorder.dart';
import '../domain/voice_recorder.dart';

final voiceRecorderProvider = Provider.autoDispose<VoiceRecorder>((ref) {
  final config = ref.watch(appConfigProvider);
  final VoiceRecorder recorder = config.useFakeNativeAdapters
      ? FakeVoiceRecorder()
      : NativeVoiceRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

final voiceRecordingStateProvider = StreamProvider.autoDispose<Duration>((ref) {
  final recorder = ref.watch(voiceRecorderProvider);
  return recorder.durationStream;
});
