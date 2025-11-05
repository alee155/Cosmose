import 'dart:convert';

// Category Model
class Category {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String photo;
  final bool isParent;
  final bool isSubCategory;
  final bool isChildSubCategory;
  final int? parentId;
  final String platform;
  final String? addedBy;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.photo,
    required this.isParent,
    required this.isSubCategory,
    required this.isChildSubCategory,
    this.parentId,
    required this.platform,
    this.addedBy,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      photo: json['photo'] ?? '',
      isParent: json['is_parent'] == 1,
      isSubCategory: json['is_sub_category'] == 1 ? true : false,
      isChildSubCategory: json['is_child_sub_category'] == 1 ? true : false,
      parentId: json['parent_id'],
      platform: json['platform'] ?? 'Unknown',
      addedBy: json['added_by'],
      status: json['status'] ?? 'inactive',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "slug": slug,
      "summary": summary,
      "photo": photo,
      "is_parent": isParent ? 1 : 0,
      "is_sub_category": isSubCategory ? 1 : 0,
      "is_child_sub_category": isChildSubCategory ? 1 : 0,
      "parent_id": parentId,
      "platform": platform,
      "added_by": addedBy,
      "status": status,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  static List<Category> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }
}
