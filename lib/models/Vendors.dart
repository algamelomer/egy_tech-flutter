// ignore_for_file: unnecessary_cast

class Vendor {
  final int vendorId;
  final String brandName;
  final String vendorImage;
  final String description;
  final String phone;
  final String status;
  final List<Region> regions;
  final String createdAt;
  final String updatedAt;

  Vendor({
    this.vendorId = 0,
    this.brandName = '',
    this.vendorImage = '',
    this.description = '',
    this.phone = '',
    this.status = '',
    this.regions = const [],
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'] ?? json['id'] ?? 0,
      brandName: json['brand_name']?.toString() ?? '',
      vendorImage: json['vendor_image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      regions: (json['regions'] as List<dynamic>? ?? [])
          .map((region) => Region.fromJson(region))
          .toList(),
    );
  }
}

// region model for vendor page

class Region {
  final int id;
  final String name;
  final int vendorId;
  final int regionId;
  final int deliveryCost;
  final int discount;
  final String description;

  Region({
    this.id = 0,
    this.name = '',
    this.vendorId = 0,
    this.regionId = 0,
    this.deliveryCost = 0,
    this.discount = 0,
    this.description = '',
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      vendorId: json['vendor_id'] ?? 0,
      regionId: json['region_id'] ?? 0,
      deliveryCost: json['delivery_cost'] ?? 0,
      discount: json['discount'] ?? 0,
      description: json['description']?.toString() ?? '',
    );
  }
}
