/// Speech-to-text for recorded voice notes.
abstract interface class SpeechTranscriber {
  /// Text spoken in the audio file at [path]; empty when nothing was heard.
  /// [language] (ISO 639-1, e.g. `vi`) avoids misdetection on short or
  /// quiet recordings. Throws `AppFailure`.
  Future<String> transcribe(
    String path, {
    required String mimeType,
    String? language,
  });
}
