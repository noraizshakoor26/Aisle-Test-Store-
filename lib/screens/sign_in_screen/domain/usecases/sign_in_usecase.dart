import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_request_model.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_response_model.dart';
import 'package:test_store/screens/sign_in_screen/domain/repository/sign_in_repository.dart';

class SignInUseCase {
  final SignInRepository repository;

  SignInUseCase(this.repository);

  Future<Result<SignInResponseModel>> execute(SignInRequestModel request) {
    return repository.signIn(request);
  }
}
