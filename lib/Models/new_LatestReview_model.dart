// ******************** Latest_Review ********************
class LatestReview {
  final int id;
  final String user;
  final String product;
  final int rating;
  final String comment;
  final String? createdAt;

  LatestReview({
    required this.id,
    required this.user,
    required this.product,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory LatestReview.fromJson(Map<String, dynamic> json) {
    return LatestReview(
      id: json['id'],
      user: json['user'],
      product: json['product'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}
