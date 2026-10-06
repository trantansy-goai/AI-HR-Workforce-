import 'package:flutter_project_base/features/voice/data/fake_voice_recorder.dart';
import 'package:flutter_project_base/features/voice/data/native_voice_recorder.dart';
import 'package:flutter_project_base/features/voice/domain/voice_recorder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';

class MockAudioRecorder extends Mock implements AudioRecorder {}

class FakeRecordConfig extends Fake implements RecordConfig {}

void main() {
  setUpAll(() {
    registerFallbackValue(const RecordConfig());
  });

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

    test(
      'starts, records duration, stops and returns output file path',
      () async {
        expect(recorder.status, equals(RecordingStatus.idle));

        await recorder.start();
        expect(recorder.status, equals(RecordingStatus.recording));

        final outputPath = await recorder.stop();
        expect(recorder.status, equals(RecordingStatus.stopped));
        expect(outputPath, contains('fake_voice_recording.m4a'));
      },
    );

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

  group('NativeVoiceRecorder', () {
    late MockAudioRecorder mockRecorder;
    late NativeVoiceRecorder recorder;

    setUp(() {
      mockRecorder = MockAudioRecorder();
      when(() => mockRecorder.dispose()).thenAnswer((_) async {});
      recorder = NativeVoiceRecorder(recorder: mockRecorder);
    });

    tearDown(() {
      recorder.dispose();
    });

    test('delegates permission check to AudioRecorder', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      expect(await recorder.hasPermission(), isTrue);

      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => false);
      expect(await recorder.hasPermission(), isFalse);
    });

    test('throws exception when starting without microphone permission', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => false);

      await expectLater(
        () => recorder.start(customPath: '/tmp/test.m4a'),
        throwsA(isA<Exception>()),
      );
      expect(recorder.status, equals(RecordingStatus.error));
    });

    test('starts and stops recording session cleanly', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      when(
        () => mockRecorder.start(any(), path: any(named: 'path')),
      ).thenAnswer((_) async {});
      when(() => mockRecorder.stop()).thenAnswer((_) async => '/tmp/test.m4a');

      await recorder.start(customPath: '/tmp/test.m4a');
      expect(recorder.status, equals(RecordingStatus.recording));

      final result = await recorder.stop();
      expect(recorder.status, equals(RecordingStatus.stopped));
      expect(result, equals('/tmp/test.m4a'));
    });

    test('cancels recording session cleanly', () async {
      when(() => mockRecorder.hasPermission()).thenAnswer((_) async => true);
      when(
        () => mockRecorder.start(any(), path: any(named: 'path')),
      ).thenAnswer((_) async {});
      when(() => mockRecorder.cancel()).thenAnswer((_) async {});

      await recorder.start(customPath: '/tmp/test.m4a');
      expect(recorder.status, equals(RecordingStatus.recording));

      await recorder.cancel();
      expect(recorder.status, equals(RecordingStatus.idle));
      verify(() => mockRecorder.cancel()).called(1);
    });
  });
}
