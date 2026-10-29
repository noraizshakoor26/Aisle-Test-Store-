class SignInRequestModel {
  final String username;
  final String password;

  SignInRequestModel({required this.username, required this.password});

  Map<String, dynamic> toMap() => {
    'username': username,
    'password': password,
    'expiresInMins': 60,
  };
}
