/// Text-to-speech for reading answers aloud.
abstract interface class SpeechSynthesizer {
  /// Path of an audio file speaking [text]. Throws `AppFailure`.
  Future<String> synthesize(String text);
}
