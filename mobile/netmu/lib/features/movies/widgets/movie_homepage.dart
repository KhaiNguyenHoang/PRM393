import 'dart:math';

import 'package:flutter/material.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/services/movie_service.dart';
import 'package:netmu/features/movies/widgets/movie_card.dart';
import 'package:netmu/features/movies/widgets/section_header.dart';
import 'package:netmu/l10n/app_localizations.dart';

class MovieHomepage extends StatefulWidget {
  const MovieHomepage({super.key});

  @override
  State<MovieHomepage> createState() => _MovieHomepageState();
}

class _MovieHomepageState extends State<MovieHomepage> {
  // Service
  late final MovieService _service;

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  // Movie items
  List<Movie> _popular = [];
  List<Movie> _discover = [];

  // States
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int _page = 1;

  String? _error;

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
    _loadInitial();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    try {
      setState(() {
        _isInitialLoading = true;
        _error = null;
        _page = 1;
      });

      final popularResult = await _service.getMovies(1, 5);

      final discoverResult = await _service.getMovies(_page, 10);

      if (!mounted) return;

      setState(() {
        _popular = popularResult.$1;

        _discover = discoverResult.$1;

        _hasMore = discoverResult.$2;

        _isInitialLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    try {
      setState(() {
        _isLoadingMore = true;
      });

      _page++;

      final result = await _service.getMovies(_page, 10);

      if (!mounted) return;

      setState(() {
        _discover.addAll(result.$1);

        _hasMore = result.$2;

        _isLoadingMore = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),

            const SizedBox(height: 16),

            FilledButton(onPressed: _loadInitial, child: const Text("Retry")),
          ],
        ),
      );
    }

    final l10n = AppLocalizations.of(context);
    final popular = l10n?.popularSectionHeader;
    final discover = l10n?.discoverSectionHeader;

    return RefreshIndicator(
      onRefresh: _refresh,

      child: SingleChildScrollView(
        controller: _scrollController,

        physics: const BouncingScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 8),

            SectionHeader(title: popular ?? "Popular"),

            const SizedBox(height: 14),

            SizedBox(
              height: 220,

              child: ListView.separated(
                physics: const BouncingScrollPhysics(),

                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(horizontal: 20),

                itemCount: _popular.length,

                separatorBuilder: (_, _) => const SizedBox(width: 12),

                itemBuilder: (context, index) =>
                    PopularCard(movie: _popular[index]),
              ),
            ),

            const SizedBox(height: 32),

            SectionHeader(title: discover ?? "Discover"),

            const SizedBox(height: 14),

            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),

              shrinkWrap: true,

              padding: const EdgeInsets.symmetric(horizontal: 20),

              itemCount: _discover.length + (_isLoadingMore ? 1 : 0),

              separatorBuilder: (_, _) => const SizedBox(height: 14),

              itemBuilder: (context, index) {
                // Bottom loading indicator
                if (index == _discover.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return DiscoverCard(movie: _discover[index]);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
