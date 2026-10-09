import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/auth/session_status.dart';
import 'package:goai_mobile/core/storage/secure_store.dart';
import 'package:goai_mobile/features/auth/application/auth_providers.dart';
import 'package:goai_mobile/features/auth/data/auth_session_storage.dart';
import 'package:goai_mobile/features/auth/domain/auth_session.dart';
import 'package:goai_mobile/features/auth/domain/auth_state.dart';
import 'package:goai_mobile/features/auth/domain/auth_user.dart';

import '../../helpers/test_helpers.dart';

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  test('starts unknown, then unauthenticated without stored session', () async {
    final container = createTestContainer();
    expect(container.read(authControllerProvider), isA<AuthUnknown>());
    await _settle();
    await _settle();
    expect(container.read(authControllerProvider), isA<Unauthenticated>());
    expect(
      container.read(authControllerProvider).status,
      SessionStatus.signedOut,
    );
  });

  test('restores a stored session', () async {
    final secure = InMemorySecureStore();
    await AuthSessionStorage(secure).write(
      const AuthSession(
        user: AuthUser(id: 'u1', displayName: 'Mai'),
        accessToken: 'fake-access-1',
      ),
    );
    final container = createTestContainer(secureStore: secure);
    container.read(authControllerProvider);
    await _settle();
    await _settle();
    expect(container.read(authControllerProvider).user?.displayName, 'Mai');
  });

  test('drops a stored session the server rejects', () async {
    final secure = InMemorySecureStore();
    await AuthSessionStorage(secure).write(
      const AuthSession(
        user: AuthUser(id: 'u1'),
        accessToken: 'revoked',
      ),
    );
    final container = createTestContainer(secureStore: secure);
    container.read(authControllerProvider);
    await _settle();
    await _settle();
    expect(container.read(authControllerProvider), isA<Unauthenticated>());
    expect(await AuthSessionStorage(secure).read(), isNull);
  });

  test('sign in, guest and sign out update state', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);
    await _settle();

    final result = await controller.signInWithEmail(' me@x.io ', 'secret1');
    expect(result.isOk, isTrue);
    expect(container.read(authControllerProvider).user?.email, 'me@x.io');

    await controller.signOut();
    expect(container.read(authControllerProvider), isA<Unauthenticated>());

    await controller.continueAsGuest();
    final state = container.read(authControllerProvider);
    expect(state.status, SessionStatus.signedIn);
    expect(state.session?.isGuest, isTrue);
  });

  test(
    'changing the password signs out; a wrong one keeps the session',
    () async {
      final container = createTestContainer();
      final controller = container.read(authControllerProvider.notifier);
      await _settle();
      await controller.signInWithEmail('me@x.io', 'secret1');

      final wrong = await controller.changePassword(
        currentPassword: 'nope',
        newPassword: 'n3w',
      );
      expect(wrong.isOk, isFalse);
      expect(container.read(authControllerProvider), isA<Authenticated>());

      final changed = await controller.changePassword(
        currentPassword: 'demo123456',
        newPassword: 'n3w',
      );
      expect(changed.isOk, isTrue);
      expect(container.read(authControllerProvider), isA<Unauthenticated>());
    },
  );

  test('failed sign in keeps user signed out', () async {
    final container = createTestContainer();
    final controller = container.read(authControllerProvider.notifier);
    await _settle();
    await _settle();
    final result = await controller.signInWithEmail('me@x.io', '1');
    expect(result.isOk, isFalse);
    expect(container.read(authControllerProvider), isA<Unauthenticated>());
  });
}
