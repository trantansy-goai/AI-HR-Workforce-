import 'package:flutter_project_base/features/voice/data/fake_voice_recorder.dart';
import 'package:flutter_project_base/features/voice/domain/voice_recorder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeVoiceRecorder', () {
    late FakeVoiceRecorder recorder;

    setUp(() {
      recorder = FakeVoiceRecorder();
    });

    tearDown(() {
      recorder.dispose();
    });

    test('checks permission status', () async {
      expect(await recorder.hasPermission(), isTrue);
    });

    test('starts, records duration, stops and returns output file path', () async {
      expect(recorder.status, equals(RecordingStatus.idle));

      await recorder.start();
      expect(recorder.status, equals(RecordingStatus.recording));

      final outputPath = await recorder.stop();
      expect(recorder.status, equals(RecordingStatus.stopped));
      expect(outputPath, contains('fake_voice_recording.m4a'));
    });

    test('cancels recording and resets state to idle', () async {
      await recorder.start();
      expect(recorder.status, equals(RecordingStatus.recording));

      await recorder.cancel();
      expect(recorder.status, equals(RecordingStatus.idle));
    });

    test('throws exception when microphone permission is denied', () async {
      final deniedRecorder = FakeVoiceRecorder(grantPermission: false);
      expect(() => deniedRecorder.start(), throwsA(isA<Exception>()));
    });
  });
}
