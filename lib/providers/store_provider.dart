// providers/store_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/services/store_service.dart';
import 'package:my_app/models/storeData.dart';

final storeServiceProvider = Provider<StoreService>((ref) => StoreService());

final storeDataProvider =
    FutureProvider.family<Store, int>((ref, storeId) async {
  final service = ref.watch(storeServiceProvider);
  return await service.getStoreById(storeId);
});

final productsByStoreProvider =
    FutureProvider.family<List<Product>, int>((ref, storeId) async {
  final service = ref.watch(storeServiceProvider);
  return await service.getProductsByStoreId(storeId);
});
