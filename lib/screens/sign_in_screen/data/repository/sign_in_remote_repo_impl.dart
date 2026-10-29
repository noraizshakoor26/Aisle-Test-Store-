import 'package:dio/dio.dart';
import 'package:test_store/core/api/api_client.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_request_model.dart';
import 'package:test_store/screens/sign_in_screen/data/models/sign_in_response_model.dart';
import 'package:test_store/screens/sign_in_screen/domain/repository/sign_in_repository.dart';

class SignInRemoteRepoImpl implements SignInRepository {
  @override
  Future<Result<SignInResponseModel>> signIn(SignInRequestModel request) async {
    try {
      final Response response = await DioClient().post(
        'auth/login',
        data: request.toMap(),
      );
      if (response.statusCode == 200) {
        return Result.success(SignInResponseModel.fromMap(response.data));
      }
      return Result.failure(
        ServerFailure('Sign in failed.', statusCode: response.statusCode),
      );
    } on DioException catch (error) {
      return Result.failure(DioClient().handleError(error));
    } catch (error) {
      return Result.failure(UnknownFailure(error.toString()));
    }
  }
}
