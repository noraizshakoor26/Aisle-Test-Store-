class SignInResponseModel {
  final int id;
  final String accessToken;
  final String refreshToken;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;

  SignInResponseModel({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory SignInResponseModel.fromMap(Map<String, dynamic> map) {
    return SignInResponseModel(
      id: map['id'] ?? 0,
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
