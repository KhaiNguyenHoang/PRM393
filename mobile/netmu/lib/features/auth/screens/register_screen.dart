import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:netmu/core/themes/theme.dart";
import "package:netmu/core/utils/logger/logger.dart";
import "package:netmu/core/widgets/button.dart";
import "package:netmu/core/widgets/error_message.dart";
import "package:netmu/core/widgets/form_label.dart";
import "package:netmu/core/widgets/input.dart";
import "package:netmu/features/auth/models/register_dto.dart";
import "package:netmu/features/auth/services/auth_service.dart";
import "package:netmu/features/auth/widgets/auth_form_footer.dart";
import "package:netmu/l10n/app_localizations.dart";



class RegisterScreen extends StatefulWidget {
  final AuthService _service = AuthService();

  RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Loading button state
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      var deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken == null) {
        NetmuLog.logger.e("Failed to get device token");
        deviceToken = "";
      }
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
        deviceToken: deviceToken
      );
      var (success, message) = await widget._service.register(request);

      // Whether request failed or not, we both set loading state to false
      setState(() => _isLoading = false);

      // Check if success or not
      if (mounted) {
        if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              ErrorMessage(textContent: message!)
            );
          return;
        }

        // If success, redirect to login
        Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (route) => false);
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Header ===
                Text(
                  l10n.registerTitle,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: ColorTheme.textPrimary,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.registerSubtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: ColorTheme.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                // === Username field ===
                FormLabel(label: l10n.usernameLabel),
                const SizedBox(height: 8),
                StringInput(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return l10n.requiredUsername;
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
                    if (value == null || value.trim().isEmpty) return l10n.requiredEmail;
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(value.trim())) return l10n.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // === Password ===
                FormLabel(label: l10n.passwordLabel),
                const SizedBox(height: 8),
                PasswordInput(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return l10n.requiredPassword;
                    if (value.length < 8) return l10n.minPassword;
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                // === Register button ===
                FullWidthApiCallButton(
                  textButton: l10n.registerButton,
                  isLoading: _isLoading,
                  onPress: _onRegister,
                ),
                const SizedBox(height: 18),

                // === Footer ===
                AuthFormFooter(
                  text: l10n.registerFooter,
                  url: "/auth/login",
                  urlText: l10n.registerFooterAction,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
