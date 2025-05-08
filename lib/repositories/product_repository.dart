import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/config/api.dart';
import 'package:my_app/models/Product.dart';

class ProductRepository {
  final String _baseUrl = ApiConfig.baseUrl;
  final String endpoint = '/product';

  Future<ApiResponse<Product>> getProductById(id) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint/$id'));
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse<Product>.fromJson(jsonMap, Product.fromJson);
    } else {
      throw Exception("Failed to load data");
    }
  }
}

class ApiResponse<T> {
  final bool status;
  final T data;

  ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] as bool,
      data: fromJsonT(json['data'] as Map<String, dynamic>)
    );
  }
}
