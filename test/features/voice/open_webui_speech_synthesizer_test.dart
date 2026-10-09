import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/voice/data/open_webui_speech_synthesizer.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late Directory temp;
  late FakeHttpAdapter http;
  late OpenWebUiSpeechSynthesizer synthesizer;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('tts');
    http = FakeHttpAdapter({
      'POST /api/v1/audio/speech': (_) =>
          const FakeResponse('mp3-bytes', contentType: 'audio/mpeg'),
    });
    synthesizer = OpenWebUiSpeechSynthesizer(
      dio: fakeDio(http),
      baseUrl: 'https://webui.test/',
      cacheDirectory: () async => temp,
    );
  });

  tearDown(() => temp.delete(recursive: true));

  test('fetches speech once per text', () async {
    final path = await synthesizer.synthesize(' Xin chào ');
    final again = await synthesizer.synthesize('Xin chào');

    expect(again, path);
    expect(path, endsWith('.mp3'));
    expect(await File(path).readAsString(), 'mp3-bytes');
    expect(http.requests.single.data, {'input': 'Xin chào'});
  });

  test('nothing to read is a ValidationFailure without a request', () async {
    await expectLater(
      synthesizer.synthesize('  '),
      throwsA(isA<ValidationFailure>()),
    );
    expect(http.requests, isEmpty);
  });
}
