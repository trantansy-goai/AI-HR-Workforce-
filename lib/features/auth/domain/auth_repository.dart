import '../../../core/error/result.dart';
import 'auth_credential.dart';
import 'auth_session.dart';

abstract interface class AuthRepository {
  /// Loads a persisted session, checking it with the server (or refreshing
  /// it if expired).
  /// Returns `Ok(null)` when there is no usable session.
  Future<Result<AuthSession?>> restoreSession();

  Future<Result<AuthSession>> signIn(AuthCredential credential);

  /// Exchanges the stored refresh token for new tokens.
  Future<Result<AuthSession>> refreshSession();

  /// In-memory current session (no I/O).
  AuthSession? get currentSession;

  /// Clears local session; best-effort server logout.
  Future<void> signOut();

  /// Changes the signed-in user's password on the server.
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
