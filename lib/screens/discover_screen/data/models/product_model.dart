class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String sku;
  final double weight;
  final ProductDimensionsModel dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewModel> reviews;
  final String returnPolicy;
  final List<String> images;
  final String thumbnail;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.images,
    required this.thumbnail,
  });

  // DummyJSON's `price` is the list price; the discount is applied on top.
  double get finalPrice => price * (1 - discountPercentage / 100);

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (map['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      stock: map['stock'] ?? 0,
      tags: List<String>.from(map['tags'] ?? const []),
      brand: map['brand'],
      sku: map['sku'] ?? '',
      weight: (map['weight'] as num?)?.toDouble() ?? 0,
      dimensions: ProductDimensionsModel.fromMap(map['dimensions'] ?? const {}),
      warrantyInformation: map['warrantyInformation'] ?? '',
      shippingInformation: map['shippingInformation'] ?? '',
      availabilityStatus: map['availabilityStatus'] ?? '',
      reviews: (map['reviews'] as List? ?? const [])
          .map((review) => ReviewModel.fromMap(review))
          .toList(),
      returnPolicy: map['returnPolicy'] ?? '',
      images: List<String>.from(map['images'] ?? const []),
      thumbnail: map['thumbnail'] ?? '',
    );
  }
}

class ProductDimensionsModel {
  final double width;
  final double height;
  final double depth;

  ProductDimensionsModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory ProductDimensionsModel.fromMap(Map<String, dynamic> map) {
    return ProductDimensionsModel(
      width: (map['width'] as num?)?.toDouble() ?? 0,
      height: (map['height'] as num?)?.toDouble() ?? 0,
      depth: (map['depth'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ReviewModel {
  final int rating;
  final String comment;
  final DateTime? date;
  final String reviewerName;

  ReviewModel({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      date: DateTime.tryParse(map['date'] ?? ''),
      reviewerName: map['reviewerName'] ?? '',
    );
  }
}
