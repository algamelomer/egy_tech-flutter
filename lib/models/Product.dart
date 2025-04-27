// ignore_for_file: unnecessary_cast

import 'package:my_app/models/Vendors.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String averageRating;
  final List<ProductDetail> details;
  final Vendor vendor;

  Product({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.averageRating = '',
    this.details = const <ProductDetail>[],
    Vendor? vendor,
  }) : vendor = vendor ?? Vendor();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'].toString(),
      description: json['description'].toString(),
      averageRating: json['average_rating'].toString(),
      details: (json['details'] as List? ?? [])
          .map((detail) => ProductDetail.fromJson(detail))
          .toList(),
      vendor: Vendor.fromJson(json['vendor'] ?? {}),
    );
  }
}

class ProductDetail {
  final int id;
  final String size;
  final String color;
  final String price;
  final String discount;
  final int stock;
  final String material;
  final List<String> images;

  ProductDetail({
    this.id = 0,
    this.size = '',
    this.color = '',
    this.price = '',
    this.discount = '',
    this.stock = 0,
    this.material = '',
    this.images = const <String>[],
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      size: json['size'].toString(),
      color: json['color'].toString(),
      price: json['price'].toString(),
      discount: json['discount'].toString(),
      stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock'].toString()) ?? 0,
      material: json['material'].toString(),
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}
