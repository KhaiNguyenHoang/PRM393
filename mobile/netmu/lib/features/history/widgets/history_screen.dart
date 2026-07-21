import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/history/models/history.dart';
import 'package:netmu/features/history/services/history_service.dart';
import 'package:netmu/features/history/widgets/history_tile.dart';
import 'package:netmu/features/movies/services/movie_service.dart';
import 'package:netmu/features/movies/widgets/movie_detail.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryService _service;
  late final MovieService _movieService;
  List<History> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = HistoryService(
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        "/auth/login",
        (route) => false,
      ),
    );
    _movieService = MovieService(
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        "/auth/login",
        (route) => false,
      ),
    );
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final res = await _service.getHistory();
    if (mounted) {
      setState(() {
        _history = res;
        _isLoading = false;
      });
    }
  }

  Future<void> _openMovie(String movieId) async {
    final movie = await _movieService.getMovie(movieId);
    if (mounted && movie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetail(movie: movie)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: const Text(
          "Watch History",
          style: TextStyle(
            color: ColorTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(
                  child: Text(
                    "No watch history yet.",
                    style: TextStyle(color: ColorTheme.textSecondary),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadHistory,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _history.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final h = _history[index];
                      return HistoryTile(
                        history: h,
                        onTap: () => _openMovie(h.movieId),
                      );
                    },
                  ),
                ),
    );
  }
}
