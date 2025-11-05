class Product {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String description;
  final String photo;
  final List<String> images; // Changed to List<String>
  final String? video; // Made nullable
  final int stock;
  final String price;
  final String size;
  final String condition;
  final String status;
  final String vat;
  final int discount;
  final int isFeatured;
  final int catId;
  final int? childCatId; // Made nullable
  final int? childSubCatId; // Made nullable
  final int? vendorId; // Made nullable
  final String platform;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.description,
    required this.photo,
    required this.images,
    this.video,
    required this.stock,
    required this.price,
    required this.size,
    required this.condition,
    required this.status,
    required this.vat,
    required this.discount,
    required this.isFeatured,
    required this.catId,
    this.childCatId,
    this.childSubCatId,
    this.vendorId,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        slug: json['slug'] ?? '',
        summary: json['summary'] ?? '',
        description: json['description'] ?? '',
        photo: json['photo'] ?? '',
        images: json['images'] != null ? List<String>.from(json['images']) : [],
        video: json['video'],
        stock: json['stock'] ?? 0,
        price: json['price']?.toString() ?? '0.00',
        size: json['size']?.toString() ??
            '', // Convert size to string to avoid mismatches
        condition: json['condition'] ?? '',
        status: json['status'] ?? '',
        vat: json['vat']?.toString() ??
            '', // Convert vat to string to avoid errors
        discount: json['discount'] ?? 0,
        isFeatured: json['is_featured'] ?? 0,
        catId: json['cat_id'] ?? 0,
        childCatId:
            _parseInt(json['child_cat_id']), // Handle potential string values
        childSubCatId: _parseInt(
            json['child_sub_cat_id']), // Handle potential string values
        vendorId:
            _parseInt(json['vendor_id']), // Handle potential string values
        platform: json['platform'] ?? '',
        createdAt: _parseDate(json['created_at']),
        updatedAt: _parseDate(json['updated_at']),
      );
    } catch (e) {
      print('⚠️ Warning: Error parsing product: $json | Error: $e');
      return Product(
        id: 0,
        title: 'Unknown',
        slug: '',
        summary: '',
        description: '',
        photo: '',
        images: [],
        stock: 0,
        price: '0.00',
        size: '',
        condition: '',
        status: '',
        vat: '',
        discount: 0,
        isFeatured: 0,
        catId: 0,
        platform: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

// Helper function to safely parse nullable int values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value); // Convert string to int safely
    }
    return null;
  }

// Helper function to parse nullable DateTime values
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'description': description,
      'photo': photo,
      'images': images, // List<String>
      'video': video, // Nullable field
      'stock': stock,
      'price': price,
      'size': size,
      'condition': condition,
      'status': status,
      'vat': vat,
      'discount': discount,
      'is_featured': isFeatured,
      'cat_id': catId,
      'child_cat_id': childCatId, // Nullable field
      'child_sub_cat_id': childSubCatId, // Nullable field
      'vendor_id': vendorId, // Nullable field
      'platform': platform,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
}
