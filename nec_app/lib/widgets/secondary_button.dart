import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.foregroundColor = const Color(0xFF1B6A00),
    this.borderColor = Colors.grey,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle commonStyle = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: borderRadius as BorderRadius),
      ),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding),
      elevation: WidgetStateProperty.all<double>(0),
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
    );

    final Widget child = Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    final Widget button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: commonStyle.merge(
              OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                side: BorderSide(color: borderColor),
              ),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: commonStyle.merge(
              ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              ),
            ),
            child: child,
          );

    return SizedBox(width: double.infinity, height: height, child: button);
  }
}
