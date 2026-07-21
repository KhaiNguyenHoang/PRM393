class DirectorDto {
  final String id;
  final String name;
  final String bio;
  final String imageUrl;

  const DirectorDto({
    required this.id,
    required this.name,
    required this.bio,
    required this.imageUrl,
  });

  factory DirectorDto.fromJson(Map<String, dynamic> json) {
    return DirectorDto(
      id: json['id'],
      name: json['name'],
      bio: json['bio'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
