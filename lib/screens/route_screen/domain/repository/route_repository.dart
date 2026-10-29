import 'package:test_store/core/api/result.dart';

abstract class RouteRepository {
  Future<Result<void>> getMe();
}
