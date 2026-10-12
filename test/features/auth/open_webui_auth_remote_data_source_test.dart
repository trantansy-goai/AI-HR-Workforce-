import 'package:flutter_test/flutter_test.dart';
import 'package:goai_mobile/core/error/app_failure.dart';
import 'package:goai_mobile/core/network/api_client.dart';
import 'package:goai_mobile/features/auth/data/auth_remote_data_source.dart';
import 'package:goai_mobile/features/auth/domain/auth_credential.dart';
import 'package:goai_mobile/features/auth/domain/auth_session.dart';
import 'package:goai_mobile/features/auth/domain/auth_user.dart';

import '../../helpers/fake_http_adapter.dart';

const _base = 'https://webui.test';

const _sessionJson = {
  'token': 'jwt-1',
  'token_type': 'Bearer',
  'expires_at': 1767225600,
  'id': 'u-1',
  'email': 'hr@company.test',
  'name': 'HR User',
  'role': 'user',
  'profile_image_url': '/user.png',
  'permissions': {
    'chat': {'file_upload': true, 'delete': false},
    'workspace': {'models': false},
  },
};

void main() {
  late FakeHttpAdapter http;
  late OpenWebUiAuthRemoteDataSource source;

  void serve(Map<String, FakeResponse> routes) {
    http = FakeHttpAdapter({
      for (final e in routes.entries) e.key: (_) => e.value,
    });
    source = OpenWebUiAuthRemoteDataSource(
      ApiClient(fakeDio(http)),
      baseUrl: '$_base/',
    );
  }

  const credential = EmailPasswordCredential(
    email: 'hr@company.test',
    password: 'secret',
  );

  test('sign in posts credentials and maps the session', () async {
    serve({'POST /api/v1/auths/signin': const FakeResponse(_sessionJson)});

    final session = await source.signIn(credential);

    expect(http.requests.first.uri.toString(), '$_base/api/v1/auths/signin');
    expect(http.requests.first.data, {
      'email': 'hr@company.test',
      'password': 'secret',
    });
    expect(session.accessToken, 'jwt-1');
    expect(session.refreshToken, isNull);
    expect(
      session.expiresAt,
      DateTime.fromMillisecondsSinceEpoch(1767225600 * 1000),
    );
    expect(
      session.user,
      const AuthUser(
        id: 'u-1',
        email: 'hr@company.test',
        displayName: 'HR User',
        avatarUrl: '$_base/user.png',
        role: 'user',
        permissions: {'chat.file_upload'},
      ),
    );
  });

  test('a token without expiry never expires locally', () async {
    serve({
      'POST /api/v1/auths/signin': FakeResponse({
        ..._sessionJson,
        'expires_at': null,
      }),
    });

    final session = await source.signIn(credential);

    expect(session.expiresAt, isNull);
    expect(session.isExpired(DateTime(2100)), isFalse);
  });

  test('wrong credentials (400) become UnauthorizedFailure', () async {
    serve({
      'POST /api/v1/auths/signin': const FakeResponse({
        'detail': 'The email or password provided is incorrect.',
      }, status: 400),
    });

    await expectLater(
      source.signIn(credential),
      throwsA(isA<UnauthorizedFailure>()),
    );
  });

  test('guest sign-in is not supported', () async {
    serve({});
    await expectLater(
      source.signIn(const GuestCredential()),
      throwsA(isA<UnknownFailure>()),
    );
    expect(http.requests, isEmpty);
  });

  test('refresh always fails without a network call', () async {
    serve({});
    await expectLater(
      source.refresh('anything'),
      throwsA(isA<UnauthorizedFailure>()),
    );
    expect(http.requests, isEmpty);
  });

  const held = AuthSession(
    user: AuthUser(id: 'u-1'),
    accessToken: 'jwt-1',
  );

  test('verify sends the bearer token and returns fresh user data', () async {
    serve({
      'GET /api/v1/auths/': FakeResponse({..._sessionJson, 'role': 'admin'}),
    });

    final verified = await source.verify(held);

    expect(http.requests.first.headers['Authorization'], 'Bearer jwt-1');
    expect(verified.user.role, 'admin');
    expect(verified.accessToken, 'jwt-1');
  });

  test('sign in and verify read the user\'s group names', () async {
    serve({
      'POST /api/v1/auths/signin': const FakeResponse(_sessionJson),
      'GET /api/v1/auths/': const FakeResponse(_sessionJson),
      'GET /api/v1/users/groups': const FakeResponse([
        {'id': 'g-1', 'name': 'HR'},
        {'id': 'g-2', 'name': 'Managers'},
        {'id': 'g-3', 'name': ''},
      ]),
    });

    final session = await source.signIn(credential);
    final verified = await source.verify(held);

    expect(session.user.groups, {'HR', 'Managers'});
    expect(verified.user.groups, {'HR', 'Managers'});
    expect(session.user.permissions, {'chat.file_upload'});
    final groups = http.requests.where(
      (r) => r.uri.path == '/api/v1/users/groups',
    );
    expect(
      groups.map((r) => r.headers['Authorization']),
      everyElement('Bearer jwt-1'),
    );
  });

  test('change password posts both passwords with the bearer', () async {
    serve({'POST /api/v1/auths/update/password': const FakeResponse(true)});

    await source.changePassword(
      held,
      currentPassword: 'old',
      newPassword: 'new-Secret-1',
    );

    expect(http.requests.single.headers['Authorization'], 'Bearer jwt-1');
    expect(http.requests.single.data, {
      'password': 'old',
      'new_password': 'new-Secret-1',
    });
  });

  test('a wrong current password (400) is a ValidationFailure', () async {
    serve({
      'POST /api/v1/auths/update/password': const FakeResponse({
        'detail': 'Incorrect password',
      }, status: 400),
    });

    await expectLater(
      source.changePassword(held, currentPassword: 'x', newPassword: 'y'),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('unreadable groups leave them unknown', () async {
    serve({'POST /api/v1/auths/signin': const FakeResponse(_sessionJson)});

    final session = await source.signIn(credential);

    expect(session.user.groups, isNull);
    expect(session.accessToken, 'jwt-1');
  });

  test('verify surfaces 401 as UnauthorizedFailure', () async {
    serve({
      'GET /api/v1/auths/': const FakeResponse({
        'detail': 'Not authenticated',
      }, status: 401),
    });
    await expectLater(source.verify(held), throwsA(isA<UnauthorizedFailure>()));
  });

  test('sign out posts with the bearer token', () async {
    serve({
      'POST /api/v1/auths/signout': const FakeResponse({'status': true}),
    });

    await source.signOut(held);

    expect(http.calls, ['POST /api/v1/auths/signout']);
    expect(http.requests.single.headers['Authorization'], 'Bearer jwt-1');
  });

  test('flattenPermissions keeps only granted leaves', () {
    expect(
      flattenPermissions({
        'chat': {'file_upload': true, 'delete': false},
        'features': {
          'web_search': true,
          'nested': {'deep': true},
        },
        'flag': true,
        'limit': 5,
      }),
      {
        'chat.file_upload',
        'features.web_search',
        'features.nested.deep',
        'flag',
      },
    );
  });

  test('AuthUser.allows treats unknown permissions as allowed', () {
    expect(const AuthUser(id: 'x').allows('chat.file_upload'), isTrue);
    expect(
      const AuthUser(id: 'x', permissions: {}).allows('chat.file_upload'),
      isFalse,
    );
  });
}
