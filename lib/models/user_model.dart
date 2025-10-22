class AppUser {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? avatarId; // "avatar_01.png" gibi

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.avatarId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        role: json['role'] ?? 'user',
        avatarId: json['avatar_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'role': role,
        'avatar_id': avatarId,
      };
}