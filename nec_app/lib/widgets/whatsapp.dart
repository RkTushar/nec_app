import 'package:flutter/material.dart';

/// A reusable WhatsApp button widget.
///
/// - Behaves as a simple tapable image button.
/// - If [onTap] is provided, it will be called; otherwise prints a debug log.
class WhatsAppButton extends StatelessWidget {
  /// Custom tap handler. If provided, overrides default launch behavior.
  final VoidCallback? onTap;

  /// Size for the WhatsApp icon image (height in logical pixels).
  final double size;

  /// Optional semantic label for accessibility.
  final String semanticLabel;

  /// Optional decoration to wrap the image, if you need shadows/borders.
  final Decoration? decoration;

  /// Asset path to the WhatsApp image.
  final String assetPath;

  const WhatsAppButton({
    super.key,
    this.onTap,
    this.size = 40,
    this.semanticLabel = 'Contact via WhatsApp',
    this.decoration,
    this.assetPath = 'assets/images/whatsapp_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onTap ?? () { debugPrint('WhatsApp Support Clicked'); },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: decoration,
          child: Image.asset(assetPath, height: size),
        ),
      ),
    );
  }
}


