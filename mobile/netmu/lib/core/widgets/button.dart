import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class FullWidthNavigateButton extends StatelessWidget {
  final ButtonStyle buttonStyle;
  final String buttonText;
  final TextStyle textStyle;
  final VoidCallback onPress;

  const FullWidthNavigateButton({
    super.key,
    required this.buttonText,
    required this.buttonStyle,
    required this.textStyle,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        style: buttonStyle,
        onPressed: onPress,
        child: Text(buttonText, style: textStyle),
      ),
    );
  }
}

class FullWidthApiCallButton extends StatelessWidget {
  final String textButton;
  final bool isLoading;
  final VoidCallback onPress;

  const FullWidthApiCallButton({
    super.key,
    required this.textButton,
    required this.isLoading,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorTheme.buttonPrimary,
          foregroundColor: ColorTheme.textOnAccent,
          // Muted version of primary for disabled state
          disabledBackgroundColor: ColorTheme.buttonPrimary,
          disabledForegroundColor: ColorTheme.textOnAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorTheme.textOnAccent,
            ),
          ),
        )
            : Text(textButton),
      ),
    );
  }
}
