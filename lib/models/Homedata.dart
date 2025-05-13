import 'package:my_app/models/Category.dart';

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
      data: fromJsonT(json['data'] as Map<String, dynamic>),
    );
  }
}

class HomeData {
  final List<ProductList> mostDemanded;
  final List<Category> trendingCategories;
  final List<ProductList> promotedProducts;

  final List<Category> categories;

  HomeData(
      {required this.mostDemanded,
      required this.categories,
      this.trendingCategories = const [],
      required this.promotedProducts});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    var mostDemandedJson = json['most_demanded'] as List? ?? [];
    var categoriesJson = json['categories'] as List? ?? [];
    var trendingCategoriesJson = json['trending_categories'] as List? ?? [];
    var promotedProductsJson = json['promoted_products'] as List? ?? [];
    return HomeData(
      mostDemanded: mostDemandedJson
          .map((item) => ProductList.fromJson(item as Map<String, dynamic>))
          .toList(),
      categories: categoriesJson
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      trendingCategories: trendingCategoriesJson
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
      promotedProducts: promotedProductsJson
          .map((item) => ProductList.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

// product list for home page

class ProductList {
  final int productId;
  final int vendor_id;
  final String productName;
  final String productImage;
  final String vendorImage;
  final String price;
  final String discount;
  final String brandName;
  final int rating;

  ProductList({
    this.productId = 0,
    this.vendor_id = 0,
    this.productName = '',
    this.productImage = '',
    this.vendorImage = '',
    this.price = '',
    this.discount = '',
    this.brandName = '',
    this.rating = 0,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      productId: (json['product_id'] ?? json["id"]) as int,
      vendor_id: (json['vendor_id'] ?? 0) as int,
      productName: json['product_name'].toString(),
      productImage: json['product_image'].toString(),
      vendorImage: json['vendor_image'].toString(),
      price: json['price'].toString(),
      discount: json['discount'].toString(),
      brandName: json['brand_name'].toString(),
      rating: (json['rating'] ?? 0).toInt() as int,
    );
  }
}
