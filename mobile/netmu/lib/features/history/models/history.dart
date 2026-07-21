class History {
  final String id;
  final String movieId;
  final String movieTitle;
  final String movieImageUrl;
  final String watchedAt;
  final int progressInSeconds;

  const History({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.movieImageUrl,
    required this.watchedAt,
    required this.progressInSeconds,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id']?.toString() ?? '',
      movieId: json['movieId']?.toString() ?? '',
      movieTitle: json['movieTitle'] ?? '',
      movieImageUrl: json['movieImageUrl'] ?? '',
      watchedAt: json['watchedAt'] ?? '',
      progressInSeconds: json['progressInSeconds'] ?? 0,
    );
  }
}
