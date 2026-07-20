import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/widgets/movie_detail.dart';
import 'package:netmu/features/playlists/models/playlist.dart';
import 'package:netmu/features/playlists/services/playlist_service.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late final PlaylistService _service;
  List<Movie> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = PlaylistService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);
    final list = await _service.getPlaylistMovies(widget.playlist.id);
    if (mounted) {
      setState(() {
        _movies = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeMovie(Movie movie) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorTheme.surface,
        title: const Text("Remove Movie", style: TextStyle(color: ColorTheme.textPrimary)),
        content: Text("Remove '${movie.title}' from playlist?", style: const TextStyle(color: ColorTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Remove", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.removeMovieFromPlaylist(widget.playlist.id, movie.id);
      if (success) {
        await _loadMovies();
      }
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
        title: Text(
          widget.playlist.name,
          style: const TextStyle(color: ColorTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _movies.isEmpty
              ? const Center(
                  child: Text(
                    "No movies in this playlist.",
                    style: TextStyle(color: ColorTheme.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    final movie = _movies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: ColorTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: movie.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  movie.imageUrl,
                                  width: 50,
                                  height: 75,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.movie, color: ColorTheme.buttonPrimary, size: 40),
                                ),
                              )
                            : const Icon(Icons.movie, color: ColorTheme.buttonPrimary, size: 40),
                        title: Text(movie.title, style: const TextStyle(color: ColorTheme.textPrimary, fontWeight: FontWeight.bold)),
                        subtitle: Text(movie.director, style: const TextStyle(color: ColorTheme.textSecondary)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => _removeMovie(movie),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MovieDetail(movie: movie)),
                          ).then((_) {
                            _loadMovies();
                          });
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
