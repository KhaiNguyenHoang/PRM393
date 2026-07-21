import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/history/models/history.dart';

class HistoryTile extends StatelessWidget {
  final History history;
  final VoidCallback onTap;

  const HistoryTile({
    super.key,
    required this.history,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorTheme.border, width: 0.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 100,
                height: 70,
                child: CachedNetworkImage(
                  imageUrl: history.movieImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: ColorTheme.surfaceVariant,
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: ColorTheme.surfaceVariant,
                    child: const Icon(
                      Icons.movie_outlined,
                      color: ColorTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    history.movieTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatWatchedAt(history.watchedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorTheme.textSecondary,
                    ),
                  ),
                  if (history.progressInSeconds > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatProgress(history.progressInSeconds),
                      style: const TextStyle(
                        fontSize: 11,
                        color: ColorTheme.accent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: ColorTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWatchedAt(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  String _formatProgress(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return 'Watched ${h}h ${m}m ${s}s';
    if (m > 0) return 'Watched ${m}m ${s}s';
    return 'Watched ${s}s';
  }
}
