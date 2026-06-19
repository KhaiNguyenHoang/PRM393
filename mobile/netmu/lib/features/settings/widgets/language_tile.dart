import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class LanguageTile extends StatelessWidget {
  final String flag;
  final String language;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    required this.flag,
    required this.language,
    required this.code,
    required this.isSelected,
    required this.onTap,
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
            // Flag
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ColorTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(flag, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),

            // Language name
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? ColorTheme.buttonPrimary
                      : ColorTheme.textPrimary,
                ),
              ),
            ),

            // Selected checkmark
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: ColorTheme.buttonPrimary,
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                size: 20,
                color: ColorTheme.borderStrong,
              ),
          ],
        ),
      ),
    );
  }
}