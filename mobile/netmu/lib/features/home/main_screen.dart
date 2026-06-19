import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/widgets/appbar.dart';
import 'package:netmu/features/movies/widgets/movie_homepage.dart';
import 'package:netmu/features/profile/widgets/profile.dart';
import 'package:netmu/features/settings/widgets/settings.dart';
import 'package:netmu/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  Widget getPage() {
    switch (_currentIndex) {
      case 0:
        return ProfilePage();
      case 1:
        return const MovieHomepage();
      case 2:
        return const SettingsPage();
      default:
        return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: Appbar(),
      body: Container(color: ColorTheme.background, child: getPage()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ColorTheme.surface,
          border: Border(top: BorderSide(color: ColorTheme.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: ColorTheme.buttonPrimary,
          unselectedItemColor: ColorTheme.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              activeIcon: const Icon(Icons.person_rounded),
              label: l10n.navProfile,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings_rounded),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
