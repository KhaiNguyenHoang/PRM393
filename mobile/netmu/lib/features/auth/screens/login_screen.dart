import "package:flutter/material.dart";
import "package:netmu/core/themes/theme.dart";
import "package:netmu/core/widgets/error_message.dart";
import "package:netmu/features/auth/models/login_dto.dart";
import "package:netmu/features/auth/services/auth_service.dart";
import "package:netmu/features/auth/widgets/auth_form_footer.dart";
import "package:netmu/core/widgets/button.dart";
import "package:netmu/core/widgets/input.dart";
import "package:netmu/core/widgets/form_label.dart";
import "package:netmu/l10n/app_localizations.dart";



class LoginScreen extends StatefulWidget {
  final AuthService _service = AuthService();

  LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      // Set loading state
      setState(() => _isLoading = true);

      // Make request
      final username = _usernameController.text;
      final password = _passwordController.text;
      final request = LoginRequest(username: username, password: password);
      var (success, message) = await widget._service.login(request);

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
        Navigator.pushNamedAndRemoveUntil(context, "/main", (route) => false);
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
                  l10n.loginTitle,
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
                  l10n.loginSubtitle,
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

                // === Login button ===
                FullWidthApiCallButton(
                  textButton: l10n.loginButton,
                  isLoading: _isLoading,
                  onPress: _onLogin,
                ),
                SizedBox(height: 18),

                // === Footer ===
                AuthFormFooter(
                  text: l10n.loginFooter,
                  url: "/auth/register",
                  urlText: l10n.loginFooterAction,
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
