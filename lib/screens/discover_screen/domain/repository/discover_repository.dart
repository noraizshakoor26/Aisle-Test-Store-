import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/category_model.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';

abstract class DiscoverRepository {
  Future<Result<ProductsResponseModel>> getProducts({
    required int limit,
    required int skip,
  });

  Future<Result<ProductsResponseModel>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  });

  Future<Result<ProductsResponseModel>> getProductsByCategory({
    required String slug,
    required int limit,
    required int skip,
  });

  Future<Result<List<CategoryModel>>> getCategories();

  Future<Result<List<ProductModel>>> getDeals({required int limit});
}
