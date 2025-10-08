// lib/widgets/password_text_field.dart
import 'package:flutter/material.dart';
import 'package:nec_app/theme/theme_data.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'Password',
    this.onChanged,
    this.prefixIcon,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: widget.labelText,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: widget.prefixIcon != null
          ? Icon(widget.prefixIcon, color: Colors.grey)
          : null,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.card,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: _inputDecoration(),
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }
}
