import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';

class GetProductsByCategoryUseCase {
  final DiscoverRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  Future<Result<ProductsResponseModel>> execute({
    required String slug,
    required int limit,
    required int skip,
  }) {
    return repository.getProductsByCategory(
      slug: slug,
      limit: limit,
      skip: skip,
    );
  }
}
