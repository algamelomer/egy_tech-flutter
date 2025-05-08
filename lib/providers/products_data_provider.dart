import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/repositories/product_repository.dart';

final apiRepositoryProvider = Provider<ProductRepository>((ref) => ProductRepository());

final ProductDataProvider = FutureProvider.family<ApiResponse, String>((ref, id) async {
  final repository = ref.watch(apiRepositoryProvider);
  return repository.getProductById(id);
});
