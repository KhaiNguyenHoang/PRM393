import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class ErrorMessage extends SnackBar {
  final String textContent;

  ErrorMessage({super.key, required this.textContent})
    : super(
        content: Center(child: Text(textContent)),
        backgroundColor: ColorTheme.warning,
      );
}
