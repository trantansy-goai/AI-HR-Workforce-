import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_document_repository.dart';
import '../domain/document_item.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return FakeDocumentRepository();
});

final documentsProvider = FutureProvider.autoDispose<List<DocumentItem>>((
  ref,
) async {
  final repository = ref.watch(documentRepositoryProvider);
  return repository.getDocuments();
});

final documentDetailProvider = FutureProvider.autoDispose
    .family<DocumentItem, String>((ref, id) async {
      final repository = ref.watch(documentRepositoryProvider);
      return repository.getDocumentDetail(id);
    });
