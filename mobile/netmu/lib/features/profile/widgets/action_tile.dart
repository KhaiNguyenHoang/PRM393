import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color labelColor;
  final Color iconColor;
  final bool showChevron;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor = ColorTheme.textPrimary,
    this.iconColor = ColorTheme.textSecondary,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ColorTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),
            // Chevron
            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: ColorTheme.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
