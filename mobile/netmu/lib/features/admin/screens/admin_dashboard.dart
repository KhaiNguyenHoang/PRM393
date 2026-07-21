import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/utils/api/token_storage.dart';
import 'package:netmu/features/admin/models/analytics.dart';
import 'package:netmu/features/admin/screens/admin_catalog_screen.dart';
import 'package:netmu/features/admin/screens/admin_movie_list.dart';
import 'package:netmu/features/admin/screens/admin_user_list.dart';
import 'package:netmu/features/admin/services/admin_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late final AdminService _service;
  Analytics? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = AdminService(
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        "/auth/login",
        (route) => false,
      ),
    );
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final data = await _service.getAnalytics();
    if (mounted) {
      setState(() {
        _analytics = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: const Text(
          "Admin",
          style: TextStyle(
            color: ColorTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (_analytics != null) ...[
                    _buildStatRow(_analytics!),
                    const SizedBox(height: 32),
                  ],
                  _buildMenuItem(
                    icon: Icons.movie_rounded,
                    title: "Movies",
                    subtitle: "Add, edit, or remove movies",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminMovieList()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.people_rounded,
                    title: "Users",
                    subtitle: "View and manage users",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminUserList()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.category_rounded,
                    title: "Catalog",
                    subtitle: "Manage genres, directors, and actors",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminCatalogScreen()),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: ColorTheme.border, height: 0.5),
                  const SizedBox(height: 16),
                  _buildLogoutTile(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatRow(Analytics analytics) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.people_outline,
            label: "Users",
            value: analytics.totalUsers.toString(),
            color: ColorTheme.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.movie_outlined,
            label: "Movies",
            value: analytics.totalMovies.toString(),
            color: ColorTheme.buttonPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.visibility_outlined,
            label: "Views",
            value: analytics.totalViews.toString(),
            color: ColorTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.block,
            label: "Banned",
            value: analytics.bannedCount.toString(),
            color: ColorTheme.buttonDanger,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorTheme.border, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: ColorTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: ColorTheme.buttonDanger),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final storage = SecureTokenStorage();
      await storage.clearTokens();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (route) => false);
      }
    }
  }

  Widget _buildLogoutTile() {
    return GestureDetector(
      onTap: _logout,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorTheme.buttonDanger.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorTheme.buttonDanger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: ColorTheme.buttonDanger, size: 24),
            ),
            const SizedBox(width: 16),
            const Text(
              "Log Out",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorTheme.buttonDanger,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorTheme.border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: ColorTheme.buttonPrimary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: ColorTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
