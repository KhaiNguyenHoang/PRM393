import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/admin/screens/admin_movie_form.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/services/movie_service.dart';

class AdminMovieList extends StatefulWidget {
  const AdminMovieList({super.key});

  @override
  State<AdminMovieList> createState() => _AdminMovieListState();
}

class _AdminMovieListState extends State<AdminMovieList> {
  late final MovieService _service;
  List<Movie> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = MovieService(
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        "/auth/login",
        (route) => false,
      ),
    );
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final res = await _service.getMovies(1, 100);
    if (mounted) {
      setState(() {
        _movies = res.$1;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteMovie(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Movie"),
        content: const Text("Are you sure you want to delete this movie?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: ColorTheme.buttonDanger),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _service.deleteMovie(id);
      await _loadMovies();
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
          "Manage Movies",
          style: TextStyle(color: ColorTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.buttonPrimary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminMovieForm()),
          );
          _loadMovies();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMovies,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                itemCount: _movies.length,
                separatorBuilder: (_, __) => const Divider(height: 1, color: ColorTheme.border),
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 50,
                        height: 70,
                        child: Image.network(
                          movie.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: ColorTheme.surfaceVariant,
                            child: const Icon(Icons.movie_outlined),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorTheme.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      movie.genreNames.join(', '),
                      style: const TextStyle(color: ColorTheme.textSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: ColorTheme.info, size: 20),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminMovieForm(movie: movie),
                              ),
                            );
                            _loadMovies();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: ColorTheme.buttonDanger, size: 20),
                          onPressed: () => _deleteMovie(movie.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
