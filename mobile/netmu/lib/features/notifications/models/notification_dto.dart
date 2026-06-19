class NotificationDto {
  final String title;
  final String message;

  const NotificationDto({required this.title, required this.message});

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      title: json["title"] as String,
      message: json["message"] as String,
    );
  }
}
