import 'package:flutter/material.dart';

/// A compact secondary-style button for the £5 invite action.
/// Matches the styling currently used on the Home screen for the £5 button
/// while being reusable across the app.
class InviteButton2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const InviteButton2({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final Color resolvedForeground = foregroundColor ?? Colors.white;

    return SizedBox(
      height: 33,
      width: 73,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedForeground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '£5',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            ColorFiltered(
              colorFilter: ColorFilter.mode(resolvedForeground, BlendMode.srcIn),
              child: Image.asset('assets/icons/gift_icon.png', width: 20, height: 20),
            ),
          ],
        ),
      ),
    );
  }
}


