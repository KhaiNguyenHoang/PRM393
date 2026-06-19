import "package:flutter/material.dart";
import "package:netmu/core/themes/theme.dart";

class FormLabel extends StatelessWidget {
  final String label;

  const FormLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ColorTheme.textPrimary,
        letterSpacing: 0.3,
      ),
    );
  }
}