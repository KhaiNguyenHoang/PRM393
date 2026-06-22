import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';

class AuthFormFooter extends StatelessWidget {
  final String text;
  final String urlText;
  final String url;

  const AuthFormFooter({
    super.key,
    required this.text,
    required this.url,
    required this.urlText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: '$text ',
          style: const TextStyle(
            color: ColorTheme.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, url);
                },
                child: Text(
                  urlText,
                  style: TextStyle(
                  color: ColorTheme.buttonPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: ColorTheme.buttonPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
