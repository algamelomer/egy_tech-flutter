// models/Category.dart
import 'dart:convert';
import 'package:my_app/models/homedata.dart';

// category model for home page
class Category {
  final int id;
  final String categoryName;
  final String description;
  final String categoryImage;
  final List<ProductList> products;

  Category({
    this.id = 0,
    this.categoryName = '',
    this.description = '',
    this.categoryImage = '',
    this.products = const <ProductList>[],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List? ?? [];
    return Category(
      id: (json['category_id'] ?? json['id']) as int,
      categoryName: (json['category_name'] ?? json['name']).toString(),
      description: json['description'].toString(),
      categoryImage: (json['category_image'] ?? json['image']).toString(),
      products: productsJson
          .map((item) => ProductList.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

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
