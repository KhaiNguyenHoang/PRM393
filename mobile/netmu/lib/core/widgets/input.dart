import 'package:flutter/material.dart';
import 'package:netmu/core/themes/input_decoration.dart';

class StringInput extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const StringInput({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: CustomInputDecoration(hint: hint, icon: icon),
      validator: validator,
    );
  }
}

class EmailInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;

  const EmailInput({
    super.key,
    required this.hint,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: CustomInputDecoration(
        hint: hint,
        icon: Icons.mail_outline_rounded,
      ),
      validator: validator,
    );
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;

  const PasswordInput({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isPasswordHidden,
      textInputAction: TextInputAction.done,
      decoration:
          CustomInputDecoration(
            hint:
                'Password must have at least 1 lowercase, 1 uppercase, 1 alphanumeric and 8 characters long',
            icon: Icons.lock_outline_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF7A7A9D),
                size: 20,
              ),

              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            ),
          ),
      validator: widget.validator,
    );
  }
}
