part of 'sign_in_bloc.dart';

class SignInState {
  final StatusIndicator status;
  final String? errorMessage;

  const SignInState({this.status = StatusIndicator.idle, this.errorMessage});

  SignInState copyWith({
    StatusIndicator? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignInState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
