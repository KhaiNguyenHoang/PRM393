import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/favorites/models/favorite_movie.dart';
import 'package:netmu/features/favorites/services/favorite_service.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoriteService _service;
  List<FavoriteMovie> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = FavoriteService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final res = await _service.getFavorites(1, 100);
    if (mounted) {
      setState(() {
        _favorites = res.$1;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: const Text(
          "My Favorites",
          style: TextStyle(color: ColorTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(child: Text("No favorites yet.", style: TextStyle(color: ColorTheme.textSecondary)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final fav = _favorites[index];
                    // Convert FavoriteMovie to a mock Movie to reuse DiscoverCard
                    final mockMovie = Movie(
                      id: fav.movieId,
                      title: fav.title,
                      description: "",
                      director: "",
                      genres: [],
                      durationInMinutes: 0,
                      videoUrl: "",
                      imageUrl: fav.imageUrl,
                    );
                    return DiscoverCard(movie: mockMovie);
                  },
                ),
    );
  }
}
