import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/admin/models/user_admin.dart';
import 'package:netmu/features/admin/services/admin_service.dart';

class AdminUserList extends StatefulWidget {
  const AdminUserList({super.key});

  @override
  State<AdminUserList> createState() => _AdminUserListState();
}

class _AdminUserListState extends State<AdminUserList> {
  late final AdminService _service;
  List<UserAdmin> _users = [];
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
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _service.getAllUsers();
    if (mounted) {
      setState(() {
        _users = users;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBan(UserAdmin user) async {
    final success = user.isBanned
        ? await _service.unbanUser(user.id)
        : await _service.banUser(user.id);
    if (success) {
      _loadUsers();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              user.isBanned ? "Failed to unban user" : "Failed to ban user",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: const Text(
          "Manage Users",
          style: TextStyle(
            color: ColorTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _users.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: ColorTheme.border,
                ),
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: user.isBanned
                          ? ColorTheme.buttonDanger.withValues(alpha: 0.15)
                          : ColorTheme.success.withValues(alpha: 0.15),
                      child: Text(
                        user.username.isNotEmpty
                            ? user.username[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: user.isBanned
                              ? ColorTheme.buttonDanger
                              : ColorTheme.success,
                        ),
                      ),
                    ),
                    title: Text(
                      user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorTheme.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      "${user.email}  •  ${user.role}",
                      style: const TextStyle(
                        color: ColorTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: user.role == "admin"
                        ? null
                        : TextButton(
                            onPressed: () => _toggleBan(user),
                            style: TextButton.styleFrom(
                              foregroundColor: user.isBanned
                                  ? ColorTheme.success
                                  : ColorTheme.buttonDanger,
                            ),
                            child: Text(user.isBanned ? "Unban" : "Ban"),
                          ),
                  );
                },
              ),
            ),
    );
  }
}
