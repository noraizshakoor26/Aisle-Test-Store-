class CategoryModel {
  final String slug;
  final String name;

  CategoryModel({required this.slug, required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(slug: map['slug'] ?? '', name: map['name'] ?? '');
  }
}
