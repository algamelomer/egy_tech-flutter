// repositories/category_repository.dart
import 'package:my_app/services/category_service.dart';
import 'package:my_app/models/Category.dart';

class CategoryRepository {
  final CategoryService _categoryService = CategoryService();

  Future<List<CategoryProduct>> getCategoryProducts(int categoryId) async {
    return await _categoryService.getCategoryProducts(categoryId);
  }
}
