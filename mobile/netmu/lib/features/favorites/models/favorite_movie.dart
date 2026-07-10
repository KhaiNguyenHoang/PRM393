class FavoriteMovie {
  final String id;
  final String movieId;
  final String title;
  final String imageUrl;
  final String createdAt;

  FavoriteMovie({
    required this.id,
    required this.movieId,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
  });

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
      id: json['id'],
      movieId: json['movieId'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
    );
  }
}
