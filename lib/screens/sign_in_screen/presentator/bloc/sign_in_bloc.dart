import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/core/models/user_session.dart';
import 'package:test_store/core/services/navigator_service.dart';
import 'package:test_store/core/services/secure_storage_service.dart';
import 'package:test_store/screens/discover_screen/presentator/view/discover_screen.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_request_model.dart';
import 'package:test_store/screens/sign_in_screen/domain/repository/sign_in_repository.dart';
import 'package:test_store/screens/sign_in_screen/domain/usecases/sign_in_usecase.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _signIn;

  SignInBloc({required SignInRepository repository})
    : _signIn = SignInUseCase(repository),
      super(const SignInState()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignInErrorCleared>(_onErrorCleared);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: StatusIndicator.loading, clearError: true));

    final request = SignInRequestModel(
      username: event.username.trim(),
      password: event.password,
    );
    final result = await _signIn.execute(request);

    await result.fold(
      onFailure: (failure) async {
        HapticFeedback.heavyImpact();
        final isBadCredentials =
            failure is ValidationFailure || failure is UnauthorizedFailure;
        emit(
          state.copyWith(
            status: StatusIndicator.failed,
            errorMessage: isBadCredentials
                ? 'Incorrect username or password.'
                : failure.message,
          ),
        );
      },
      onSuccess: (response) async {
        await SecureStorageService().saveUserSession(
          UserSession(
            id: response.id,
            token: response.accessToken,
            refreshToken: response.refreshToken,
            username: response.username,
            email: response.email,
            firstName: response.firstName,
            lastName: response.lastName,
            image: response.image,
          ),
        );
        HapticFeedback.lightImpact();
        emit(state.copyWith(status: StatusIndicator.active));
        NavigatorService().pushAndRemoveUntil(
          const DiscoverScreen(),
          fade: true,
        );
      },
    );
  }

  void _onErrorCleared(SignInErrorCleared event, Emitter<SignInState> emit) {
    if (state.errorMessage == null && state.status != StatusIndicator.failed) {
      return;
    }
    emit(state.copyWith(status: StatusIndicator.idle, clearError: true));
  }
}
