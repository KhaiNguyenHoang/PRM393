import "package:flutter/material.dart";
import 'package:netmu/core/themes/theme.dart';

/// Custom input decoration style
class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({required String hint, required IconData icon})
    : super(
        hintText: hint,
        hintStyle: const TextStyle(
          color: ColorTheme.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: ColorTheme.textSecondary, size: 20),
        filled: true,
        fillColor: ColorTheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        // Idle — subtle stone border, matches surfaceVariant
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorTheme.border, width: 1.5),
        ),
        // Focused — forest green accent border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTheme.buttonPrimary,
            width: 1.8,
          ),
        ),
        // Validation error — danger red border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTheme.buttonDanger,
            width: 1.5,
          ),
        ),
        // Focused + error state
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTheme.buttonDanger,
            width: 1.8,
          ),
        ),
        // Disabled state
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorTheme.borderStrong,
            width: 1.5,
          ),
        ),
        // Error message
        errorStyle: const TextStyle(
          color: ColorTheme.buttonDanger,
          fontSize: 12,
        ),
      );
}
