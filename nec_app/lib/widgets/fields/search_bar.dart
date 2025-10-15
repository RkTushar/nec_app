import 'package:flutter/material.dart';
import 'package:nec_app/theme/theme_data.dart';

/// Reusable search bar used across the app
class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmittedIcon;
  final EdgeInsetsGeometry margin;

  const AppSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onSubmittedIcon,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: onSubmittedIcon != null
              ? IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onSubmittedIcon,
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                )
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
        ),
        style: const TextStyle(color: AppColors.textPrimary),
      ),
    );
  }
}


