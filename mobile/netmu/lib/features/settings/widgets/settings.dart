import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/settings/services/locale_provider.dart';
import 'package:netmu/features/settings/widgets/language_tile.dart';
import 'package:netmu/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _onLanguageTap(String code) {
    final newLocale = Locale(code);
    final current = LocaleProvider.instance.locale;
    if (newLocale != current) {
      LocaleProvider.instance.setLocale(newLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = LocaleProvider.instance.locale;
    final l10n = AppLocalizations.of(context);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Text(
          l10n?.settingSectionHeader ?? "LANGUAGE",
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: ColorTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: ColorTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColorTheme.border, width: 0.5),
          ),
          child: Column(
            children: [
              LanguageTile(
                flag: '🇬🇧',
                language: 'English',
                code: 'en',
                isSelected: locale.languageCode == 'en',
                onTap: () => _onLanguageTap('en'),
              ),
              const Divider(
                height: 0.5,
                thickness: 0.5,
                color: ColorTheme.border,
                indent: 52,
              ),
              LanguageTile(
                flag: '🇻🇳',
                language: 'Tiếng Việt',
                code: 'vi',
                isSelected: locale.languageCode == 'vi',
                onTap: () => _onLanguageTap('vi'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
