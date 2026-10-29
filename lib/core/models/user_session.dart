class UserSession {
  final int id;
  final String token;
  final String refreshToken;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  const UserSession({
    required this.id,
    required this.token,
    required this.refreshToken,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
  });
}
