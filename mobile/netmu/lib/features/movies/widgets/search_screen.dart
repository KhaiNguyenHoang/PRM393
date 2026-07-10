import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/services/movie_service.dart';
import 'package:netmu/features/movies/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final MovieService _service;
  final TextEditingController _controller = TextEditingController();
  List<Movie> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _service = MovieService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _search(query);
      } else {
        setState(() {
          _results = [];
        });
      }
    });
  }

  Future<void> _search(String query) async {
    setState(() => _isLoading = true);
    final res = await _service.getMovies(1, 50, searchKeyword: query);
    if (mounted) {
      setState(() {
        _results = res.$1;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          autofocus: true,
          style: const TextStyle(color: ColorTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: "Search movies...",
            hintStyle: TextStyle(color: ColorTheme.textSecondary),
            border: InputBorder.none,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return DiscoverCard(movie: _results[index]);
              },
            ),
    );
  }
}
