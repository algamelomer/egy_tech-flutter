// services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/Category.dart';
import 'package:my_app/config/api.dart';

class CategoryService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<CategoryProduct>> getCategoryProducts(int categoryId) async {
    final url = '$_baseUrl/category/$categoryId/products';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['status'] != true) {
          throw Exception('Failed to load category products');
        }

        final List<CategoryProduct> products = (json['data'] as List)
            .map((item) => CategoryProduct.fromJson(item))
            .toList();

        return products;
      } else {
        throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching category products: $e');
    }
  }
}
