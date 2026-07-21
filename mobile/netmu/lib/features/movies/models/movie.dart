import 'package:netmu/features/movies/models/genre_dto.dart';
import 'package:netmu/features/movies/models/director_dto.dart';
import 'package:netmu/features/movies/models/actor_dto.dart';

class Movie {
  final String id;
  final String title;
  final String description;
  final List<GenreDto> genres;
  final List<DirectorDto> directors;
  final List<ActorDto> actors;
  final int durationInMinutes;
  final String videoUrl;
  final String imageUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.genres,
    required this.directors,
    required this.actors,
    required this.durationInMinutes,
    required this.videoUrl,
    required this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      durationInMinutes: json["durationInMinutes"] as int,
      genres: (json["genres"] as List?)
              ?.map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      directors: (json["directors"] as List?)
              ?.map((e) => DirectorDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      actors: (json["actors"] as List?)
              ?.map((e) => ActorDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: json["imageUrl"] as String? ?? '',
      videoUrl: json["videoUrl"] as String? ?? '',
    );
  }

  List<String> get genreNames => genres.map((g) => g.name).toList();

  String get directorNames =>
      directors.map((d) => d.name).join(', ');

  String get actorNames => actors.map((a) => a.name).join(', ');
}
