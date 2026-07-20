import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/favorites/services/favorite_service.dart';

class FavoriteButton extends StatefulWidget {
  final String movieId;

  const FavoriteButton({super.key, required this.movieId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late final FavoriteService _service;
  bool _isFavorite = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = FavoriteService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    // Simple check: fetch favorites and see if this movie is in the list
    final res = await _service.getFavorites(1, 100);
    if (mounted) {
      setState(() {
        _isFavorite = res.$1.any((element) => element.movieId == widget.movieId);
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoading = true);
    if (_isFavorite) {
      final success = await _service.removeFavorite(widget.movieId);
      if (success) {
        setState(() => _isFavorite = false);
      }
    } else {
      final success = await _service.addFavorite(widget.movieId);
      if (success) {
        setState(() => _isFavorite = true);
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: _isFavorite ? Colors.red : ColorTheme.textPrimary,
      ),
      onPressed: _toggleFavorite,
    );
  }
}
