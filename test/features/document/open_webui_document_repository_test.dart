import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/features/document/data/open_webui_document_repository.dart';

import '../../helpers/fake_http_adapter.dart';

const _base = 'https://webui.test';

Map<String, Object?> _file(String id, String name, {int created = 0}) => {
  'id': id,
  'filename': name,
  'meta': {'name': name, 'content_type': 'application/pdf', 'size': 2516582},
  'created_at': created,
};

void main() {
  late Directory temp;
  late FakeHttpAdapter http;
  late OpenWebUiDocumentRepository repository;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('docs');
  });

  tearDown(() => temp.delete(recursive: true));

  void serve(Map<String, FakeResponse Function(RequestOptions)> routes) {
    http = FakeHttpAdapter(routes);
    repository = OpenWebUiDocumentRepository(
      dio: fakeDio(http),
      baseUrl: '$_base/',
      downloadDirectory: () async => temp,
    );
  }

  test(
    'lists the files of every readable knowledge base, newest first',
    () async {
      serve({
        'GET /api/v1/knowledge/': (_) => const FakeResponse({
          'items': [
            {'id': 'kb-1', 'name': 'HR Policies'},
            {'id': 'kb-2', 'name': 'Payroll'},
          ],
          'total': 2,
        }),
        'GET /api/v1/knowledge/kb-1/files': (_) => FakeResponse({
          'items': [
            _file('f-1', 'leave.pdf', created: 1791000000),
            _file('f-2', 'handbook.docx', created: 1792000000),
          ],
          'total': 2,
        }),
        // The same file in two bases is listed once.
        'GET /api/v1/knowledge/kb-2/files': (_) => FakeResponse({
          'items': [_file('f-1', 'leave.pdf', created: 1791000000)],
          'total': 1,
        }),
      });

      final documents = await repository.getDocuments();

      expect(documents.map((d) => d.id), ['f-2', 'f-1']);
      final leave = documents.last;
      expect(leave.title, 'leave.pdf');
      expect(leave.description, 'HR Policies');
      expect(leave.fileType, 'PDF');
      expect(leave.fileSizeFormatted, '2.4 MB');
      expect(leave.downloadUrl, '$_base/api/v1/files/f-1/content');
      expect(
        leave.createdAt,
        DateTime.fromMillisecondsSinceEpoch(1791000000 * 1000),
      );
      expect(await repository.getDocumentDetail('f-1'), leave);
    },
  );

  test('reads every page of a knowledge base', () async {
    serve({
      'GET /api/v1/knowledge/': (_) => const FakeResponse({
        'items': [
          {'id': 'kb-1', 'name': 'HR'},
        ],
        'total': 1,
      }),
      'GET /api/v1/knowledge/kb-1/files': (r) => FakeResponse({
        'items': [_file('f-${r.queryParameters['page']}', 'p.pdf')],
        'total': 2,
      }),
    });

    final documents = await repository.getDocuments();

    expect(documents.map((d) => d.id), unorderedEquals(['f-1', 'f-2']));
  });

  test('looks up an unknown document by file id', () async {
    serve({
      'GET /api/v1/files/f-9': (_) => FakeResponse(_file('f-9', 'memo.txt')),
    });

    final document = await repository.getDocumentDetail('f-9');

    expect(document.title, 'memo.txt');
    expect(document.fileType, 'TXT');
    expect(document.description, '');
  });

  test('downloads with the session and keeps the file name', () async {
    serve({
      'GET /api/v1/files/f-9': (_) => FakeResponse(_file('f-9', 'a/b.pdf')),
      'GET /api/v1/files/f-9/content': (_) =>
          const FakeResponse('PDF bytes', contentType: 'application/pdf'),
    });
    final document = await repository.getDocumentDetail('f-9');

    final path = await repository.download(document);

    expect(path, '${temp.path}/documents/f-9/a_b.pdf');
    expect(await File(path).readAsString(), 'PDF bytes');
  });

  test('surfaces server errors as AppFailure', () async {
    serve({
      'GET /api/v1/knowledge/': (_) =>
          const FakeResponse({'detail': 'Forbidden'}, status: 403),
    });

    await expectLater(
      repository.getDocuments(),
      throwsA(isA<ForbiddenFailure>()),
    );
  });
}
