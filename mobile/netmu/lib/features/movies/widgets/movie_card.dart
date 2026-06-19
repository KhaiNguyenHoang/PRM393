import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/widgets/badges.dart';
import 'package:netmu/features/movies/widgets/movie_banner.dart';
import 'package:netmu/features/movies/widgets/movie_detail.dart';
import 'package:netmu/features/movies/widgets/movie_title.dart';

class PopularCard extends StatelessWidget {
  final Movie movie;

  const PopularCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetail(movie: movie)),
        );
      },
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MovieCardBanner(url: movie.imageUrl),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            MovieTitle(title: movie.title, maxLine: 2),
          ],
        ),
      ),
    );
  }
}

class DiscoverCard extends StatelessWidget {
  final Movie movie;

  const DiscoverCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetail(movie: movie)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorTheme.border, width: 0.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Landscape image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: MovieCardBanner(url: movie.imageUrl),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  MovieTitle(title: movie.title, maxLine: 2),
                  const SizedBox(height: 8),

                  // Genres + duration row
                  Row(
                    children: [
                      // Genre chips
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: movie.genres
                              // .map((g) => GenreBadge(label: g))
                              .map((g) => CustomBadge(icon: null, label: g))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Duration
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomBadge(
                            icon: Icons.schedule_rounded,
                            label: movie.durationInMinutes.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
