import 'package:dio/dio.dart';
import 'package:test_store/core/api/api_client.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/route_screen/domain/repository/route_repository.dart';

class RouteRemoteRepoImpl implements RouteRepository {
  @override
  Future<Result<void>> getMe() async {
    try {
      final Response response = await DioClient().get(
        'auth/me',
        requiresToken: true,
      );
      if (response.statusCode == 200) return Result.success();
      return Result.failure(
        ServerFailure('Session check failed.', statusCode: response.statusCode),
      );
    } on DioException catch (error) {
      return Result.failure(DioClient().handleError(error));
    } catch (error) {
      return Result.failure(UnknownFailure(error.toString()));
    }
  }
}
