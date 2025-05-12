// models/Category.dart
import 'dart:convert';

class CategoryProductsResponse {
  final bool status;
  final List<CategoryProduct> data;

  CategoryProductsResponse({
    required this.status,
    required this.data,
  });

  factory CategoryProductsResponse.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    final dataJson = json['data'] as List;

    final List<CategoryProduct> products =
        dataJson.map((item) => CategoryProduct.fromJson(item)).toList();

    return CategoryProductsResponse(
      status: json['status'],
      data: products,
    );
  }
}

class CategoryProduct {
  final int id;
  final String productName;
  final String description;
  final String imageUrl;
  final String price;
  final String discount;
  final String size;

  CategoryProduct({
    required this.id,
    required this.productName,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
    required this.size,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: json['price'] ?? '0.00',
      discount: json['discount'] ?? '0.00',
      size: json['size'] ?? '',
    );
  }
}
