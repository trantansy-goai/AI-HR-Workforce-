import 'package:equatable/equatable.dart';

/// Identity of the signed-in principal. Deliberately minimal: business
/// profile data belongs to the profile feature or the consuming app.
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.isAnonymous = false,
    this.role,
    this.permissions,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as String,
    email: json['email'] as String?,
    displayName: json['displayName'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    isAnonymous: json['isAnonymous'] as bool? ?? false,
    role: json['role'] as String?,
    permissions: (json['permissions'] as List<dynamic>?)
        ?.map((p) => p.toString())
        .toSet(),
  );

  final String id;
  final String? email;
  final String? displayName;
  final String? avatarUrl;

  /// True for guest sessions.
  final bool isAnonymous;

  /// Server-assigned role (e.g. `admin`, `user`), when the backend has one.
  final String? role;

  /// Granted permissions as dotted keys (e.g. `chat.file_upload`), as
  /// reported by the server. Null when the backend reports none; UI gating
  /// is a convenience only, the server still enforces access.
  final Set<String>? permissions;

  /// False only when the server reported permissions and [permission] is not
  /// among them.
  bool allows(String permission) =>
      permissions == null || permissions!.contains(permission);

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'isAnonymous': isAnonymous,
    'role': role,
    'permissions': permissions?.toList(),
  };

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    avatarUrl,
    isAnonymous,
    role,
    permissions,
  ];
}
