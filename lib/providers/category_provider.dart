// providers/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/repositories/category_repository.dart';
import 'package:my_app/models/Category.dart';

// Provider for the CategoryRepository
final categoryRepositoryProvider =
    Provider<CategoryRepository>((ref) => CategoryRepository());

// Provider to get products by category ID
final categoryProductsProvider =
    FutureProvider.family<List<CategoryProduct>, int>((ref, categoryId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategoryProducts(categoryId);
});


final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories();
});