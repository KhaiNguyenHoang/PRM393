class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String deviceToken;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.deviceToken
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "deviceToken": deviceToken
    };
  }
}