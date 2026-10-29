import 'package:dio/dio.dart';
import 'package:test_store/core/api/api_client.dart';
import 'package:test_store/core/api/failures.dart';
import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/category_model.dart';
import 'package:test_store/screens/discover_screen/data/models/product_model.dart';
import 'package:test_store/screens/discover_screen/data/models/products_response_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';

class DiscoverRemoteRepoImpl implements DiscoverRepository {
  Future<Result<T>> _get<T>(
    String path,
    Map<String, dynamic> queryParameters,
    T Function(dynamic data) parse,
  ) async {
    try {
      final Response response = await DioClient().get(
        path,
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        return Result.success(parse(response.data));
      }
      return Result.failure(
        ServerFailure('Something went wrong.', statusCode: response.statusCode),
      );
    } on DioException catch (error) {
      return Result.failure(DioClient().handleError(error));
    } catch (error) {
      return Result.failure(UnknownFailure(error.toString()));
    }
  }

  @override
  Future<Result<ProductsResponseModel>> getProducts({
    required int limit,
    required int skip,
  }) {
    return _get(
      'products',
      {'limit': limit, 'skip': skip},
      (data) => ProductsResponseModel.fromMap(data),
    );
  }

  @override
  Future<Result<ProductsResponseModel>> searchProducts({
    required String query,
    required int limit,
    required int skip,
  }) {
    return _get(
      'products/search',
      {'q': query, 'limit': limit, 'skip': skip},
      (data) => ProductsResponseModel.fromMap(data),
    );
  }

  @override
  Future<Result<ProductsResponseModel>> getProductsByCategory({
    required String slug,
    required int limit,
    required int skip,
  }) {
    return _get(
      'products/category/$slug',
      {'limit': limit, 'skip': skip},
      (data) => ProductsResponseModel.fromMap(data),
    );
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() {
    return _get(
      'products/categories',
      const {},
      (data) => (data as List)
          .map((category) => CategoryModel.fromMap(category))
          .toList(),
    );
  }

  @override
  Future<Result<List<ProductModel>>> getDeals({required int limit}) {
    return _get(
      'products',
      {'sortBy': 'discountPercentage', 'order': 'desc', 'limit': limit},
      (data) => ProductsResponseModel.fromMap(data).products,
    );
  }
}
