// ******************** Latest_posts  // ********************

class LatestPost {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String image;
  final String createdAt;

  LatestPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.image,
    required this.createdAt,
  });

  factory LatestPost.fromJson(Map<String, dynamic> json) {
    return LatestPost(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
