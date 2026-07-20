class Review {
  final String id;
  final String userId;
  final String userName;
  final String movieId;
  final String content;
  final int? rating;
  final String createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.movieId,
    required this.content,
    this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'] ?? "Unknown",
      movieId: json['movieId'],
      content: json['content'],
      rating: json['rating'],
      createdAt: json['createdAt'],
    );
  }
}
