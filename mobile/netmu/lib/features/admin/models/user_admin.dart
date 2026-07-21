class UserAdmin {
  final String id;
  final String username;
  final String email;
  final String role;
  final int status;

  const UserAdmin({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.status,
  });

  factory UserAdmin.fromJson(Map<String, dynamic> json) {
    return UserAdmin(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  bool get isBanned => status == 1;
}
