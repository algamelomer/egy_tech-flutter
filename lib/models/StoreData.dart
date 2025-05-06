// models/store_model.dart
class Store {
  final int vendorId;
  final String brandName;
  final String description;
  final String phone;
  final String status;
  final String vendorImage;
  final int followersCount;
  final List<Region> regions;

  Store({
    required this.vendorId,
    required this.brandName,
    required this.description,
    required this.phone,
    required this.status,
    required this.vendorImage,
    required this.followersCount,
    required this.regions,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      vendorId: json['vendor_id'],
      brandName: json['brand_name'],
      description: json['description'],
      phone: json['phone'],
      status: json['status'],
      vendorImage: json['vendor_image'],
      followersCount: json['followers_count'],
      regions: List.from(json['regions'] ?? [])
          .map((region) => Region.fromJson(region))
          .toList(),
    );
  }
}

class Region {
  final int regionId;
  final String regionName;
  final int deliveryCost;
  final int discount;

  Region({
    required this.regionId,
    required this.regionName,
    required this.deliveryCost,
    required this.discount,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      regionId: json['region_id'],
      regionName: json['region_name'],
      deliveryCost: json['delivery_cost'],
      discount: json['discount'],
    );
  }
}

class Product {
  final int productId;
  final String productName;
  final String description;
  final String price;
  final String discount;
  final int stock;
  final String productImage;
  final double rating;

  Product({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.discount,
    required this.stock,
    required this.productImage,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      description: json['description'],
      price: json['price'],
      discount: json['discount'],
      stock: json['stock'],
      productImage: json['product_image'],
      rating: json['rating'].toDouble(),
    );
  }
}
