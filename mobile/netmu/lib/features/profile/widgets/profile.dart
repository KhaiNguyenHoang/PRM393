import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/profile/models/profile_dto.dart';
import 'package:netmu/features/profile/services/profile_service.dart';
import 'package:netmu/features/profile/widgets/action_tile.dart';
import 'package:netmu/features/profile/widgets/change_password.dart';
import 'package:netmu/features/profile/widgets/section_label.dart';
import 'package:netmu/features/profile/widgets/update_profile.dart';
import 'package:netmu/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileService _service;

  UserProfile? _profile;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _service = ProfileService();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final profile = await _service.getProfile();

      if (!mounted) return;

      if (profile == null) {
        setState(() {
          _error = "Unexpected error occurs";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Avatar initials derived from username
  String get _initials {
    final username = _profile!.username;
    final parts = username.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return username.substring(0, username.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final l10n = AppLocalizations.of(context)!;

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),

            const SizedBox(height: 16),

            FilledButton(onPressed: _loadInitial, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    final profile = _profile!;

    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Avatar + name card ────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: ColorTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ColorTheme.border,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Avatar circle with initials
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: ColorTheme.buttonPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorTheme.borderStrong,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _initials,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: ColorTheme.textOnAccent,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Username
                          Text(
                            profile.username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: ColorTheme.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Email
                          Text(
                            profile.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorTheme.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Edit profile button
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: navigate to edit profile page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateProfile(
                                      onUpdate: _loadInitial,
                                      username: _profile!.username,
                                      email: _profile!.email,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined, size: 17),
                              label: Text(l10n.editProfile),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorTheme.buttonPrimary,
                                foregroundColor: ColorTheme.textOnAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Settings ──────────────────────────────────────────
                    SectionLabel(label: l10n.sectionSettings),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: ColorTheme.border,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          ActionTile(
                            icon: Icons.lock_outline_rounded,
                            label: l10n.changePassword,
                            onTap: () {
                              // TODO: navigate to change password page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangePassword(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Danger zone ───────────────────────────────────────
                    SectionLabel(label: l10n.sectionAccount),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: ColorTheme.border,
                          width: 0.5,
                        ),
                      ),
                      child: ActionTile(
                        icon: Icons.logout_rounded,
                        label: l10n.logOut,
                        labelColor: ColorTheme.buttonDanger,
                        iconColor: ColorTheme.buttonDanger,
                        showChevron: false,
                        onTap: () async {
                          await _service.logout();
                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/auth/login",
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
