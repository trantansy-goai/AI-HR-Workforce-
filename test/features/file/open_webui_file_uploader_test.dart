import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/file/data/open_webui_file_uploader.dart';
import 'package:goai_mobile/features/file/domain/attachment.dart';

import '../../helpers/fake_http_adapter.dart';

const _base = 'https://webui.test';

void main() {
  late Directory dir;
  late Attachment attachment;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('upload_test');
    final file = File('${dir.path}/policy.pdf')..writeAsStringSync('%PDF-1.4');
    attachment = Attachment(
      id: 'a1',
      name: 'policy.pdf',
      mimeType: 'application/pdf',
      kind: AttachmentKind.document,
      source: LocalAttachmentSource(file.path),
    );
  });

  tearDown(() => dir.delete(recursive: true));

  OpenWebUiFileUploader uploader(
    FakeHttpAdapter http, {
    Duration timeout = const Duration(minutes: 1),
  }) => OpenWebUiFileUploader(
    dio: fakeDio(http),
    baseUrl: _base,
    pollInterval: Duration.zero,
    processingTimeout: timeout,
  );

  FakeHttpAdapter server(List<Map<String, Object?>> statuses) {
    var poll = 0;
    return FakeHttpAdapter({
      'POST /api/v1/files/': (_) => const FakeResponse({
        'id': 'file-9',
        'filename': 'policy.pdf',
        'data': {'status': 'pending'},
      }),
      'GET /api/v1/files/file-9/process/status': (_) =>
          FakeResponse(statuses[poll < statuses.length - 1 ? poll++ : poll]),
    });
  }

  test(
    'uploads multipart, waits for processing, returns the file id',
    () async {
      final http = server([
        {'status': 'pending'},
        {'status': 'completed'},
      ]);
      final progress = <double>[];

      final remote = await uploader(http)
          .upload(attachment, onProgress: progress.add);

      expect(remote.storageKey, 'file-9');
      expect(remote.url, '$_base/api/v1/files/file-9/content');
      expect(http.calls, [
        'POST /api/v1/files/',
        'GET /api/v1/files/file-9/process/status',
        'GET /api/v1/files/file-9/process/status',
      ]);
      final form = http.requests.first.data as FormData;
      expect(form.files.single.key, 'file');
      expect(form.files.single.value.filename, 'policy.pdf');
      expect(progress.last, 1);
    },
  );

  test('failed processing throws ServerFailure', () async {
    final http = server([
      {'status': 'failed', 'error': 'Unsupported file'},
    ]);
    await expectLater(
      uploader(http).upload(attachment),
      throwsA(
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          contains('Unsupported file'),
        ),
      ),
    );
  });

  test('gives up when processing exceeds the timeout', () async {
    final http = server([
      {'status': 'pending'},
    ]);
    await expectLater(
      uploader(http, timeout: Duration.zero).upload(attachment),
      throwsA(isA<NetworkFailure>()),
    );
  });

  test('rejected uploads surface the HTTP failure', () async {
    final http = FakeHttpAdapter({
      'POST /api/v1/files/': (_) =>
          const FakeResponse({'detail': 'File too large'}, status: 413),
    });
    await expectLater(
      uploader(http).upload(attachment),
      throwsA(isA<ServerFailure>()),
    );
  });
}
