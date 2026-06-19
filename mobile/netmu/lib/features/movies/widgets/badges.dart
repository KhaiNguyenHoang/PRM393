import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class GenreBadge extends StatelessWidget {
  final String label;

  const GenreBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorTheme.accentSoft,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: ColorTheme.borderStrong, width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: ColorTheme.accent,
        ),
      ),
    );
  }
}

class CustomBadge extends StatelessWidget {
  final IconData? icon;
  final String label;

  const CustomBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final children = icon == null
        ? [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ColorTheme.textSecondary,
              ),
            ),
          ]
        : [
            Icon(icon, size: 13, color: ColorTheme.textSecondary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ColorTheme.textSecondary,
              ),
            ),
          ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ColorTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: ColorTheme.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
