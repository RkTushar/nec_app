import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Widget? leading;
  final Widget? trailing;
  final double fontSize;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.foregroundColor = const Color(0xFF1B6A00),
    this.borderColor = const Color(0xFFE6E6E6),
    this.height = 48,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.leading,
    this.trailing,
    this.fontSize = 16,
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

    final Widget contentRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (leading != null) leading!,
        if (leading != null) const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: foregroundColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        if (trailing != null) const SizedBox(width: 6),
        if (trailing != null) trailing!,
      ],
    );
    final Widget child = FittedBox(fit: BoxFit.scaleDown, child: contentRow);

    final Widget button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: commonStyle.merge(
              OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor, // allow white filled outlined button
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

    return SizedBox(width: width ?? double.infinity, height: height, child: button);
  }
}
