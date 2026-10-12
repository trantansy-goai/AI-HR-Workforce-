import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/core_providers.dart';
import '../data/auth_remote_data_source.dart';
import '../data/auth_repository_impl.dart';
import '../data/auth_session_storage.dart';
import '../data/fake_auth_remote_data_source.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_state.dart';
import 'auth_controller.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (ref.watch(appConfigProvider).useFakeBackend) {
    return FakeAuthRemoteDataSource();
  }
  // Public client: auth endpoints must not go through the refresh interceptor.
  return OpenWebUiAuthRemoteDataSource(
    ref.watch(publicApiClientProvider),
    baseUrl: ref.watch(appConfigProvider).openWebUiBaseUrl,
  );
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    storage: AuthSessionStorage(ref.watch(secureStoreProvider)),
    logger: ref.watch(appLoggerProvider),
  ),
);

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// SSO providers offered by the server; the sign-in page hides its SSO entry
/// when there are none (or they cannot be read).
final ssoProvidersProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  try {
    return await ref.watch(authRemoteDataSourceProvider).ssoProviders();
  } on Object {
    return const [];
  }
});
