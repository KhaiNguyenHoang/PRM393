class Movie {
  final String id;
  final String title;
  final String description;
  final String director;
  final List<String> genres;
  final int durationInMinutes;
  final String videoUrl;
  final String imageUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.genres,
    required this.durationInMinutes,
    required this.videoUrl,
    required this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      director: json["director"],
      durationInMinutes: json["durationInMinutes"] as int,
      genres: (json["genres"] as List).cast<String>(),
      imageUrl: json["imageUrl"] as String,
      videoUrl: json["videoUrl"] as String
    );
  }
}
