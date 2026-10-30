import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/api/result.dart';
import 'package:test_store/core/enums/status_indicator.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_request_model.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_response_model.dart';
import 'package:test_store/screens/sign_in_screen/domain/repository/sign_in_repository.dart';
import 'package:test_store/screens/sign_in_screen/presentator/bloc/sign_in_bloc.dart';

class FakeSignInRepository implements SignInRepository {
  FakeSignInRepository(this.failure);

  final Failure failure;
  SignInRequestModel? lastRequest;

  @override
  Future<Result<SignInResponseModel>> signIn(SignInRequestModel request) async {
    lastRequest = request;
    return Result.failure(failure);
  }
}

Matcher hasStatus(StatusIndicator status, [String? errorMessage]) =>
    isA<SignInState>()
        .having((state) => state.status, 'status', status)
        .having((state) => state.errorMessage, 'errorMessage', errorMessage);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SignInBloc', () {
    late FakeSignInRepository repository;

    blocTest<SignInBloc, SignInState>(
      'rejected credentials show one friendly message',
      setUp: () => repository = FakeSignInRepository(
        const ValidationFailure('Invalid credentials'),
      ),
      build: () => SignInBloc(repository: repository),
      act: (bloc) =>
          bloc.add(SignInRequested(username: 'emilys', password: 'wrong')),
      expect: () => [
        hasStatus(StatusIndicator.loading),
        hasStatus(StatusIndicator.failed, 'Incorrect username or password.'),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'other failures keep their own message',
      setUp: () => repository = FakeSignInRepository(
        const NetworkFailure('No internet connection.'),
      ),
      build: () => SignInBloc(repository: repository),
      act: (bloc) =>
          bloc.add(SignInRequested(username: 'emilys', password: 'pass')),
      expect: () => [
        hasStatus(StatusIndicator.loading),
        hasStatus(StatusIndicator.failed, 'No internet connection.'),
      ],
    );

    blocTest<SignInBloc, SignInState>(
      'the username is trimmed before it is sent',
      setUp: () => repository = FakeSignInRepository(
        const NetworkFailure('No internet connection.'),
      ),
      build: () => SignInBloc(repository: repository),
      act: (bloc) =>
          bloc.add(SignInRequested(username: '  emilys ', password: ' pass ')),
      verify: (_) {
        expect(repository.lastRequest?.username, 'emilys');
        expect(repository.lastRequest?.password, ' pass ');
      },
    );

    blocTest<SignInBloc, SignInState>(
      'clearing the error returns to idle',
      setUp: () => repository = FakeSignInRepository(
        const NetworkFailure('No internet connection.'),
      ),
      build: () => SignInBloc(repository: repository),
      seed: () => const SignInState(
        status: StatusIndicator.failed,
        errorMessage: 'No internet connection.',
      ),
      act: (bloc) => bloc.add(SignInErrorCleared()),
      expect: () => [hasStatus(StatusIndicator.idle)],
    );
  });
}
