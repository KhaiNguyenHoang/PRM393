import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class MovieTitle extends StatelessWidget {
  final String title;
  final int maxLine;

  const MovieTitle({super.key, required this.title, required this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ColorTheme.textPrimary,
        height: 1.3,
      ),
    );
  }
}