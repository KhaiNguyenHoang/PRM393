import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/widgets/badges.dart';
import 'package:netmu/features/movies/widgets/movie_detail_appbar.dart';
import 'package:netmu/features/movies/widgets/movie_player.dart';
import 'package:netmu/l10n/app_localizations.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;

  const MovieDetail({super.key, required this.movie});

  @override
  State<StatefulWidget> createState() {
    return _MovieDetailState();
  }
}

class _MovieDetailState extends State<MovieDetail> {
  bool _isDescriptionExpanded = false;

  Movie get movie => widget.movie;

  String get _formattedDuration {
    final h = movie.durationInMinutes ~/ 60;
    final m = movie.durationInMinutes % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom app bar
          CustomAppBar(context: context, bannerUrl: movie.imageUrl),

          // Body content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const SizedBox(height: 30),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: ColorTheme.textPrimary,
                      letterSpacing: -0.8,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Director
                  Text(
                    l10n.directedBy(movie.director),
                    style: const TextStyle(
                      fontSize: 13,
                      color: ColorTheme.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duration + genres
                  Row(
                    children: [
                      // Duration
                      CustomBadge(
                        icon: Icons.schedule_rounded,
                        label: _formattedDuration,
                      ),
                      const SizedBox(width: 8),

                      // Genres
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: movie.genres
                                .map(
                                  (g) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CustomBadge(icon: null, label: g),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Divider(color: ColorTheme.border, height: 0.5),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    l10n.synopsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ColorTheme.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: _isDescriptionExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Text(
                      movie.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorTheme.textSecondary,
                        height: 1.65,
                      ),
                    ),
                    secondChild: Text(
                      movie.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorTheme.textSecondary,
                        height: 1.65,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => setState(
                      () => _isDescriptionExpanded = !_isDescriptionExpanded,
                    ),
                    child: Text(
                      _isDescriptionExpanded ? l10n.showLess : l10n.readMore,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ColorTheme.buttonPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(color: ColorTheme.border, height: 0.5),
                  const SizedBox(height: 24),

                  Text(
                    l10n.details,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ColorTheme.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(label: l10n.infoDirector, value: movie.director),
                  _InfoRow(label: l10n.infoDuration, value: _formattedDuration),
                  _InfoRow(label: l10n.infoGenres, value: movie.genres.join(', ')),
                  const SizedBox(height: 32),

                  // Watch button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: navigate to video player with movie.videoUrl
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoPage(url: movie.videoUrl),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 22,
                      ),
                      label: Text(l10n.watchNow),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.buttonPrimary,
                        foregroundColor: ColorTheme.textOnAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColorTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ColorTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
