import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';

class GetDealsUseCase {
  final DiscoverRepository repository;

  GetDealsUseCase(this.repository);

  Future<Result<List<ProductModel>>> execute({required int limit}) {
    return repository.getDeals(limit: limit);
  }
}
