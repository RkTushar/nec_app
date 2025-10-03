// lib/widgets/custom_text_button.dart
import 'package:flutter/material.dart';

// Enum to differentiate between the link styles in the UI
enum TextButtonType { primary, link }

const Color _primaryGreen = Color(0xFF4CAF50);
const Color _linkTextColor = Colors.black54; // Used for less emphasized text

class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final TextButtonType type;

  const CustomTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = TextButtonType.link, // Defaulting to the 'link' style (Forgot Password)
  });

  // Dynamically determines the text style based on the 'type'
  TextStyle get _textStyle {
    switch (type) {
      case TextButtonType.primary:
        return const TextStyle(
          color: _primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          decoration: TextDecoration.none,
        );
      case TextButtonType.link:
        return const TextStyle(
          color: _linkTextColor,
          fontSize: 14,
          decoration: TextDecoration.none,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // Ensure minimum padding around the text
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: _textStyle,
      ),
    );
  }
}