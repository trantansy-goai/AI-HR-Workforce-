import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/di/core_providers.dart';
import '../../auth/application/auth_providers.dart';
import '../data/fake_document_repository.dart';
import '../data/open_webui_document_repository.dart';
import '../domain/document_item.dart';

/// Documents: Open WebUI knowledge bases the user may read, or fixtures with
/// the fake backend. Rebuilt per user.
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useFakeBackend) {
    return FakeDocumentRepository();
  }
  ref.watch(authControllerProvider.select((s) => s.user?.id));
  return OpenWebUiDocumentRepository(
    dio: ref.watch(authenticatedDioProvider),
    baseUrl: config.openWebUiBaseUrl,
    downloadDirectory: getApplicationCacheDirectory,
  );
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
