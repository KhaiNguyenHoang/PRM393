class ActorDto {
  final String id;
  final String name;
  final String bio;
  final String imageUrl;

  const ActorDto({
    required this.id,
    required this.name,
    required this.bio,
    required this.imageUrl,
  });

  factory ActorDto.fromJson(Map<String, dynamic> json) {
    return ActorDto(
      id: json['id'],
      name: json['name'],
      bio: json['bio'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
