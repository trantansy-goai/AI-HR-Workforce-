import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/fake_voice_recorder.dart';
import '../data/native_voice_recorder.dart';
import '../data/open_webui_speech_synthesizer.dart';
import '../data/open_webui_speech_transcriber.dart';
import '../domain/speech_synthesizer.dart';
import '../domain/speech_transcriber.dart';
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

/// Speech-to-text for voice notes: Open WebUI's configured engine, or none
/// with the fake backend (voice notes are then sent as audio only).
final speechTranscriberProvider = Provider<SpeechTranscriber?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) return null;
  return OpenWebUiSpeechTranscriber(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
  );
});

/// Reads answers aloud with the server's text-to-speech; null with the fake
/// backend or without the `chat.tts` permission.
final speechSynthesizerProvider = Provider<SpeechSynthesizer?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) return null;
  final user = ref.watch(authControllerProvider.select((s) => s.user));
  if (user == null || (user.role != 'admin' && !user.allows('chat.tts'))) {
    return null;
  }
  return OpenWebUiSpeechSynthesizer(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
    cacheDirectory: getApplicationCacheDirectory,
  );
});
