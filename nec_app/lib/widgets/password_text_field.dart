// lib/widgets/password_text_field.dart
import 'package:flutter/material.dart';

const Color _primaryGreen = Color(0xFF4CAF50);

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String labelText;
  final ValueChanged<String>? onChanged;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.validator,
    this.labelText = 'Password',
    this.onChanged,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: widget.labelText,
      labelStyle: const TextStyle(color: Colors.black54),
      // Optional: remove prefix icon for login per request
      // prefixIcon intentionally omitted
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.black54,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: _primaryGreen, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
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
      style: const TextStyle(color: Colors.black),
    );
  }
}
