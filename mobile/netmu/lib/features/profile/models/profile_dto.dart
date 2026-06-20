class UserProfile {
  final String id;
  final String username;
  final String email;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"],
      username: json["username"],
      email: json["email"],
    );
  }
}

class UpdateUserProfile {
  final String username;
  final String email;

  const UpdateUserProfile({required this.username, required this.email});

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email};
  }
}

class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {"oldPassword": oldPassword, "newPassword": newPassword};
  }
}
