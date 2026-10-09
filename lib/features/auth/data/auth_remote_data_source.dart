import 'package:dio/dio.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../domain/auth_credential.dart';
import '../domain/auth_session.dart';
import '../domain/auth_user.dart';

/// Talks to the auth backend. Implementations throw [AppFailure].
abstract interface class AuthRemoteDataSource {
  Future<AuthSession> signIn(AuthCredential credential);
  Future<AuthSession> refresh(String refreshToken);

  /// Checks a stored session with the server and returns it with up-to-date
  /// user data. Throws [UnauthorizedFailure] when the token is rejected.
  Future<AuthSession> verify(AuthSession session);

  Future<void> signOut(AuthSession session);
}

/// Open WebUI auth (`/api/v1/auths/*`).
///
/// Sign-in exchanges email + password for a JWT; there is no refresh token,
/// so an expired or rejected JWT ends the session (the user signs in again).
///
/// Sign-in / session response (`SessionUserResponse`):
/// `{"token": "...", "token_type": "Bearer", "expires_at": 1767225600 | null,
///   "id": "...", "email": "...", "name": "...", "role": "user",
///   "profile_image_url": "...", "permissions": {"chat": {"file_upload": true}}}`
class OpenWebUiAuthRemoteDataSource implements AuthRemoteDataSource {
  OpenWebUiAuthRemoteDataSource(this._client, {required String baseUrl})
    : _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

  /// Must be a client without the auth interceptor: these calls set the
  /// bearer header themselves and must not trigger session-expiry handling.
  final ApiClient _client;
  final String _baseUrl;

  @override
  Future<AuthSession> signIn(AuthCredential credential) async {
    final EmailPasswordCredential(:email, :password) = switch (credential) {
      final EmailPasswordCredential c => c,
      _ => throw UnknownFailure(
        '${credential.runtimeType} is not supported by Open WebUI',
      ),
    };
    try {
      final json = await _client.post<Map<String, dynamic>>(
        '$_baseUrl/api/v1/auths/signin',
        data: {'email': email, 'password': password},
      );
      return _parseSession(json);
    } on ValidationFailure catch (failure) {
      // Open WebUI answers wrong credentials with 400.
      throw UnauthorizedFailure(failure.message, failure.cause);
    }
  }

  @override
  Future<AuthSession> refresh(String refreshToken) async =>
      throw const UnauthorizedFailure(
        'Open WebUI sessions cannot be refreshed',
      );

  @override
  Future<AuthSession> verify(AuthSession session) async {
    final json = await _client.get<Map<String, dynamic>>(
      '$_baseUrl/api/v1/auths/',
      options: _bearer(session),
    );
    final verified = _parseSession(json);
    // The server may echo a different token; keep the one we hold unless
    // it sent a usable replacement.
    return verified.accessToken.isEmpty
        ? AuthSession(
            user: verified.user,
            accessToken: session.accessToken,
            expiresAt: verified.expiresAt ?? session.expiresAt,
          )
        : verified;
  }

  @override
  Future<void> signOut(AuthSession session) async {
    await _client.post<dynamic>(
      '$_baseUrl/api/v1/auths/signout',
      options: _bearer(session),
    );
  }

  Options _bearer(AuthSession session) =>
      Options(headers: {'Authorization': 'Bearer ${session.accessToken}'});

  AuthSession _parseSession(Map<String, dynamic> json) {
    try {
      final expiresAt = json['expires_at'] as int?;
      return AuthSession(
        accessToken: json['token'] as String? ?? '',
        expiresAt: expiresAt == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000),
        user: AuthUser(
          id: json['id'].toString(),
          email: json['email'] as String?,
          displayName: json['name'] as String?,
          avatarUrl: _absoluteUrl(json['profile_image_url'] as String?),
          role: json['role'] as String?,
          permissions: switch (json['permissions']) {
            final Map<String, dynamic> map => flattenPermissions(map),
            _ => null,
          },
        ),
      );
    } on Object catch (error) {
      throw UnknownFailure('Malformed auth response', error);
    }
  }

  /// Open WebUI returns relative paths and inline `data:` images; only keep
  /// values an image widget can load.
  String? _absoluteUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    if (url.startsWith('/')) return '$_baseUrl$url';
    return null;
  }
}

/// `{"chat": {"file_upload": true, "delete": false}}` → `{"chat.file_upload"}`.
Set<String> flattenPermissions(
  Map<String, dynamic> tree, [
  String prefix = '',
]) {
  return {
    for (final MapEntry(:key, :value) in tree.entries)
      ...switch (value) {
        true => {'$prefix$key'},
        final Map<String, dynamic> nested => flattenPermissions(
          nested,
          '$prefix$key.',
        ),
        _ => const <String>{},
      },
  };
}
