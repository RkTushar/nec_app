import 'package:flutter/material.dart';

/// Circular WhatsApp-style send button with light green background and no shadow.
class WhatsAppButton extends StatelessWidget {
  /// Called when the button is tapped.
  final VoidCallback? onTap;

  /// Overall diameter of the circular button in logical pixels.
  final double size;

  /// Background color of the circular button. Defaults to WhatsApp light green.
  final Color backgroundColor;

  /// Color tint applied to the logo. Defaults to white.
  final Color iconColor;

  /// Optional semantic label for accessibility.
  final String semanticLabel;

  /// Asset path to the WhatsApp image.
  final String assetPath;

  const WhatsAppButton({
    super.key,
    this.onTap,
    this.size = 40,
    this.backgroundColor = const Color(0xFF25D366),
    this.iconColor = Colors.white,
    this.semanticLabel = 'Send on WhatsApp',
    this.assetPath = 'assets/images/whatsapp_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * 0.54; // keep proportions similar to a FAB

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap ?? () { debugPrint('WhatsApp button tapped'); },
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              child: Image.asset(
                assetPath,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


