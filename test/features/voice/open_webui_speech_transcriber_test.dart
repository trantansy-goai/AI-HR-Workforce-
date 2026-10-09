import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/voice/data/open_webui_speech_transcriber.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late File audio;

  setUp(() async {
    audio = File('${Directory.systemTemp.path}/voice_test.m4a');
    await audio.writeAsBytes([0, 1, 2, 3]);
  });

  tearDown(() => audio.delete());

  test('uploads the recording and returns the trimmed text', () async {
    final http = FakeHttpAdapter({
      'POST /api/v1/audio/transcriptions': (_) =>
          const FakeResponse({'text': ' Tôi muốn xin nghỉ phép. '}),
    });
    final transcriber = OpenWebUiSpeechTranscriber(
      dio: fakeDio(http),
      baseUrl: 'https://webui.test/',
    );

    final text = await transcriber.transcribe(
      audio.path,
      mimeType: 'audio/mp4',
    );

    expect(text, 'Tôi muốn xin nghỉ phép.');
    final form = http.requests.single.data as FormData;
    expect(form.files.single.key, 'file');
    expect(form.files.single.value.filename, 'voice_test.m4a');
    expect(form.files.single.value.contentType.toString(), 'audio/mp4');
  });

  test('server errors surface as AppFailure', () async {
    final transcriber = OpenWebUiSpeechTranscriber(
      dio: fakeDio(
        FakeHttpAdapter({
          'POST /api/v1/audio/transcriptions': (_) =>
              const FakeResponse({'detail': 'No STT engine'}, status: 500),
        }),
      ),
      baseUrl: 'https://webui.test',
    );

    await expectLater(
      transcriber.transcribe(audio.path, mimeType: 'audio/mp4'),
      throwsA(isA<ServerFailure>()),
    );
  });
}
