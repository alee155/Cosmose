// ******************** Interesting_Articles  // ********************
class InterestingArticle {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String image;
  final String createdAt;

  InterestingArticle({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.image,
    required this.createdAt,
  });

  factory InterestingArticle.fromJson(Map<String, dynamic> json) {
    return InterestingArticle(
      id: json['id'] ?? 0, // Default to 0 if null
      title: json['title'] ?? 'No Title', // Handle missing title
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      image: json['image'] ?? '', // Handle missing image URL
      createdAt: json['created_at'] ?? '', // Handle missing date
    );
  }
}
