import 'package:test_store/screens/discover_screen/data/models/product_model.dart';

class ProductsResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponseModel.fromMap(Map<String, dynamic> map) {
    return ProductsResponseModel(
      products: (map['products'] as List? ?? const [])
          .map((product) => ProductModel.fromMap(product))
          .toList(),
      total: map['total'] ?? 0,
      skip: map['skip'] ?? 0,
      limit: map['limit'] ?? 0,
    );
  }
}
