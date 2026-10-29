part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class SignInRequested extends SignInEvent {
  final String username;
  final String password;

  SignInRequested({required this.username, required this.password});
}

class SignInErrorCleared extends SignInEvent {}
