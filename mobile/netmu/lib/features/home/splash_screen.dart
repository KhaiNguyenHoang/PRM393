import "package:flutter/material.dart";
import "package:netmu/core/themes/theme.dart";
import "package:netmu/core/widgets/button.dart";
import "package:netmu/l10n/app_localizations.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ColorTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            spacing: 40,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/images/logo.png")),

              Text(
                l10n.welcomeTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                  color: ColorTheme.textPrimary,
                ),
              ),

              // Primary action — forest green, white label
              FullWidthNavigateButton(
                buttonText: l10n.registerButton,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return ColorTheme.buttonPrimaryHover;
                    }
                    return ColorTheme.buttonPrimary;
                  }),
                  elevation: WidgetStateProperty.all(0),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                textStyle: const TextStyle(
                  color: ColorTheme.textOnAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onPress: () => Navigator.pushNamed(context, "/auth/register"),
              ),

              // Secondary action — surface bg, primary text, bordered
              FullWidthNavigateButton(
                buttonText: l10n.loginButton,
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return ColorTheme.surfaceVariant;
                    }
                    return ColorTheme.surface;
                  }),
                  elevation: WidgetStateProperty.all(0),
                  side: WidgetStateProperty.all(
                    const BorderSide(color: ColorTheme.border, width: 1.5),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                textStyle: const TextStyle(
                  color: ColorTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onPress: () => Navigator.pushNamed(context, "/auth/login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
