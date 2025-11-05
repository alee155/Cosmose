// ******************** featured_Products  // ********************
class FeaturedProduct {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String description;
  final String photo;
  final List<String> images;
  final String video;
  final int stock;
  final String price;
  final String size;
  final String condition;
  final String status;
  final String vat;
  final int discount;
  final int isFeatured;
  final int catId;
  final String platform;
  final String createdAt;
  final String updatedAt;

  FeaturedProduct({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.description,
    required this.photo,
    required this.images,
    required this.video,
    required this.stock,
    required this.price,
    required this.size,
    required this.condition,
    required this.status,
    required this.vat,
    required this.discount,
    required this.isFeatured,
    required this.catId,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    return FeaturedProduct(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'] ?? '',
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      video: json['video'] ?? '',
      stock: json['stock'] ?? 0,
      price: json['price'] ?? '0.00',
      size: json['size'] ?? '',
      condition: json['condition'] ?? '',
      status: json['status'] ?? '',
      vat: json['vat'] ?? '0',
      discount: json['discount'] ?? 0,
      isFeatured: json['is_featured'] ?? 0,
      catId: json['cat_id'] ?? 0,
      platform: json['platform'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
