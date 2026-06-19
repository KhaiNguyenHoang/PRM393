import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class MovieCardBanner extends StatelessWidget {
  final String url;

  const MovieCardBanner({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (_, _) => Container(
        color: ColorTheme.surfaceVariant,
        child: const Center(
          child: SizedBox(
            width: 22, height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorTheme.buttonPrimary,
            ),
          ),
        ),
      ),
      errorWidget: (_, _, _) => Container(
        color: ColorTheme.surfaceVariant,
        child: const Icon(
          Icons.movie_outlined,
          color: ColorTheme.textSecondary,
          size: 36,
        ),
      ),
    );
  }
}
