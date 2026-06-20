import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/widgets/button.dart';
import 'package:netmu/core/widgets/error_message.dart';
import 'package:netmu/core/widgets/form_label.dart';
import 'package:netmu/core/widgets/input.dart';
import 'package:netmu/features/profile/models/profile_dto.dart';
import 'package:netmu/features/profile/services/profile_service.dart';
import 'package:netmu/l10n/app_localizations.dart';

class UpdateProfile extends StatefulWidget {
  final _service = ProfileService();
  final String username;
  final String email;
  final VoidCallback onUpdate;
  UpdateProfile({
    super.key,
    required this.username,
    required this.email,
    required this.onUpdate,
  });

  @override
  State<StatefulWidget> createState() {
    return _UpdateProfileState();
  }
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  void _onUpdateProfile() async {
    if (_key.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final req = UpdateUserProfile(
        username: _usernameController.text,
        email: _emailController.text,
      );
      var (success, message) = await widget._service.updateProfile(req);

      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(ErrorMessage(textContent: message));
          return;
        }

        widget.onUpdate();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
      ),
      backgroundColor: ColorTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Username field ===
                FormLabel(label: l10n.usernameLabel),
                const SizedBox(height: 8),
                StringInput(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return l10n.requiredUsername;
                    if (value.trim().length < 3) return l10n.minUsername;
                    return null;
                  },
                  hint: l10n.usernameHint,
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 20),

                // === Email field ===
                FormLabel(label: l10n.emailLabel),
                const SizedBox(height: 8),
                EmailInput(
                  hint: l10n.emailHint,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return l10n.requiredEmail;
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(value.trim()))
                      return l10n.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // === Update profile button ===
                FullWidthApiCallButton(
                  textButton: l10n.updateProfileButton,
                  isLoading: _isLoading,
                  onPress: _onUpdateProfile,
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
