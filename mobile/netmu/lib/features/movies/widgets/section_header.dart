import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ColorTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}