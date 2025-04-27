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
  final String productName;
  final String productImage;
  final String vendorImage;
  final String price;
  final String discount;
  final String brandName;
  final int rating;

  ProductList({
    this.productId = 0,
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
      productName: json['product_name'].toString() as String,
      productImage: json['product_image'].toString() as String,
      vendorImage: json['vendor_image'].toString() as String,
      price: json['price'].toString() as String,
      discount: json['discount'].toString() as String,
      brandName: json['brand_name'].toString() as String,
      rating: (json['rating'] ?? 0).toInt() as int,
    );
  }
}

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
      categoryName: json['category_name'].toString() as String,
      description: json['description'].toString() as String,
      categoryImage: json['category_image'].toString() as String,
      products: productsJson
          .map((item) => ProductList.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
