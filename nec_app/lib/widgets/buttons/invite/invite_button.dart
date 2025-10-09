import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A compact secondary-style button for the Invite action.
/// Matches styling used on the Home screen for the Invite button
/// while being reusable across the app.
class InviteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const InviteButton({
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
      width: 140,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedForeground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Invite',
              style: TextStyle(fontWeight: FontWeight.w600, color: resolvedForeground),
            ),
            const SizedBox(width: 8),
            ColorFiltered(
              colorFilter: ColorFilter.mode(resolvedForeground, BlendMode.srcIn),
              child: SvgPicture.asset('assets/icons/person_add_icon.svg', width: 20, height: 20),
            ),
          ],
        ),
      ),
    );
  }
}


