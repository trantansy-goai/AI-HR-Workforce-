/// Speech-to-text for recorded voice notes.
abstract interface class SpeechTranscriber {
  /// Text spoken in the audio file at [path]; empty when nothing was heard.
  /// Throws `AppFailure`.
  Future<String> transcribe(String path, {required String mimeType});
}
