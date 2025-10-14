// lib/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nec_app/theme/theme_data.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.onSuffixTap,
    this.inputFormatters,
    this.autovalidateMode,
  });

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      // Show hint when empty and float label on focus/input
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintText: labelText,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey)
          : null,
      suffixIcon: suffixIcon != null
          ? (onSuffixTap != null
              ? IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Clear',
                  onPressed: onSuffixTap,
                  icon: Icon(suffixIcon, color: AppColors.textSecondary),
                )
              : Icon(suffixIcon, color: AppColors.textSecondary))
          : null,
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
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: autovalidateMode,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: _inputDecoration(context),
      style: const TextStyle(color: AppColors.textPrimary),
    );
  }
}
