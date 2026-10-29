import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_request_model.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_response_model.dart';

abstract class SignInRepository {
  Future<Result<SignInResponseModel>> signIn(SignInRequestModel request);
}
