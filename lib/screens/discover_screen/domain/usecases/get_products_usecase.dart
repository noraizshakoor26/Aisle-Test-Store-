import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';

class GetProductsUseCase {
  final DiscoverRepository repository;

  GetProductsUseCase(this.repository);

  Future<Result<ProductsResponseModel>> execute({
    required int limit,
    required int skip,
  }) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}
