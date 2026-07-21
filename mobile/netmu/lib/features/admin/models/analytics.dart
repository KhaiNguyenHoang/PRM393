class Analytics {
  final int totalUsers;
  final int totalMovies;
  final int totalViews;
  final int bannedCount;

  const Analytics({
    required this.totalUsers,
    required this.totalMovies,
    required this.totalViews,
    required this.bannedCount,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      totalUsers: json['totalUsers'] ?? 0,
      totalMovies: json['totalMovies'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      bannedCount: json['bannedCount'] ?? 0,
    );
  }
}
