import 'package:test_store/core/api/result.dart';
import 'package:test_store/screens/discover_screen/data/models/category_model.dart';
import 'package:test_store/screens/discover_screen/domain/repository/discover_repository.dart';

class GetCategoriesUseCase {
  final DiscoverRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Result<List<CategoryModel>>> execute() {
    return repository.getCategories();
  }
}
