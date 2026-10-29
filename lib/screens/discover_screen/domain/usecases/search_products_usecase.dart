import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';

class SearchProductsUseCase {
  final DiscoverRepository repository;

  SearchProductsUseCase(this.repository);

  Future<Result<ProductsResponseModel>> execute({
    required String query,
    required int limit,
    required int skip,
  }) {
    return repository.searchProducts(query: query, limit: limit, skip: skip);
  }
}
