// ******************** Trending_posts  // ********************
class TrendingPost {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String image;

  TrendingPost({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.image,
  });

  factory TrendingPost.fromJson(Map<String, dynamic> json) {
    return TrendingPost(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      image: json['image'] ?? '',
      summary: json['summary'],
    );
  }
}
