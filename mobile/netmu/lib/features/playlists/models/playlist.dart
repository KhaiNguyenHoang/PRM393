class Playlist {
  final String id;
  final String name;
  final int movieCount;
  final DateTime createdAt;
  final List<String> movieIds;

  Playlist({
    required this.id,
    required this.name,
    required this.movieCount,
    required this.createdAt,
    required this.movieIds,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      name: json['name'] as String,
      movieCount: json['movieCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      movieIds: (json['movieIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
