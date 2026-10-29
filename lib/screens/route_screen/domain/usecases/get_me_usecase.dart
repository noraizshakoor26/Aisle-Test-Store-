import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/route_screen/domain/repository/route_repository.dart';

class GetMeUseCase {
  final RouteRepository repository;

  GetMeUseCase(this.repository);

  Future<Result<void>> execute() {
    return repository.getMe();
  }
}
