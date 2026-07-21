import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/utils/api/token_storage.dart';
import 'package:netmu/core/widgets/appbar.dart';
import 'package:netmu/features/admin/screens/admin_dashboard.dart';
import 'package:netmu/features/favorites/widgets/favorites_screen.dart';
import 'package:netmu/features/history/widgets/history_screen.dart';
import 'package:netmu/features/movies/widgets/movie_homepage.dart';
import 'package:netmu/features/profile/widgets/profile.dart';
import 'package:netmu/features/settings/widgets/settings.dart';
import 'package:netmu/l10n/app_localizations.dart';

String? getRoleFromToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    String payload = parts[1];
    payload = payload.padRight(
      payload.length + (4 - payload.length % 4) % 4,
      '=',
    );
    final decoded = utf8.decode(base64Url.decode(payload));
    final json = jsonDecode(decoded) as Map<String, dynamic>;
    return json[
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
        as String?;
  } catch (_) {
    return null;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final storage = SecureTokenStorage();
    final token = await storage.getAccessToken();
    if (token != null && mounted) {
      final role = getRoleFromToken(token);
      final admin = role == 'admin';
      setState(() {
        _isAdmin = admin;
        if (admin) _currentIndex = 0;
      });
    }
  }

  List<BottomNavigationBarItem> _buildItems(AppLocalizations l10n) {
    if (_isAdmin) {
      return [
        BottomNavigationBarItem(
          icon: const Icon(Icons.admin_panel_settings_outlined),
          activeIcon: const Icon(Icons.admin_panel_settings_rounded),
          label: l10n.navAdmin,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          activeIcon: const Icon(Icons.settings_rounded),
          label: l10n.navSettings,
        ),
      ];
    }
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline_rounded),
        activeIcon: const Icon(Icons.person_rounded),
        label: l10n.navProfile,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.history_rounded),
        activeIcon: const Icon(Icons.history_rounded),
        label: l10n.navHistory,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home_rounded),
        label: l10n.navHome,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.favorite_border_rounded),
        activeIcon: const Icon(Icons.favorite_rounded),
        label: l10n.navFavorites,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings_outlined),
        activeIcon: const Icon(Icons.settings_rounded),
        label: l10n.navSettings,
      ),
    ];
  }

  Widget getPage() {
    if (_isAdmin) {
      switch (_currentIndex) {
        case 0:
          return const AdminDashboard();
        case 1:
          return const SettingsPage();
      }
    } else {
      switch (_currentIndex) {
        case 0:
          return ProfilePage();
        case 1:
          return const HistoryScreen();
        case 2:
          return const MovieHomepage();
        case 3:
          return const FavoritesScreen();
        case 4:
          return const SettingsPage();
      }
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: Appbar(isAdmin: _isAdmin),
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
          items: _buildItems(l10n),
        ),
      ),
    );
  }
}
