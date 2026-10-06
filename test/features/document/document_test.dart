import 'package:flutter_project_base/features/document/data/fake_document_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeDocumentRepository', () {
    late FakeDocumentRepository repo;

    setUp(() {
      repo = FakeDocumentRepository();
    });

    test('fetches document list', () async {
      final docs = await repo.getDocuments();
      expect(docs.length, greaterThanOrEqualTo(3));
      expect(docs.first.title, contains('Security Guidelines'));
    });

    test('fetches document detail by id', () async {
      final doc = await repo.getDocumentDetail('doc-102');
      expect(doc.id, equals('doc-102'));
      expect(doc.fileType, equals('PDF'));
    });
  });
}
