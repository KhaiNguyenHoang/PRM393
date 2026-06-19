import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/l10n/app_localizations.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: ColorTheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 30,
              color: ColorTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyNotifications,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ColorTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.emptyNotificationsSub,
            style: const TextStyle(
              fontSize: 14,
              color: ColorTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}