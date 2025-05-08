// services/store_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/config/api.dart';
import 'package:my_app/models/storeData.dart';

class StoreService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<Store> getStoreById(int storeId) async {
    final response = await http.get(Uri.parse('$_baseUrl/store/$storeId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body)['data'];
      return Store.fromJson(json['store']);
    } else {
      throw Exception('Failed to load store');
    }
  }

  Future<List<Product>> getProductsByStoreId(int storeId) async {
    final response = await http.get(Uri.parse('$_baseUrl/store/$storeId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body)['data'];
      final List productsJson = json['products'] as List;
      return productsJson
          .map((prodJson) => Product.fromJson(prodJson))
          .toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to load products');
    }
  }
}
