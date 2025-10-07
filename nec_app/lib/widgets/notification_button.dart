import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const NotificationButton({
    super.key,
    this.count = 0,
    this.onTap,
    this.size = 40,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.icon = Icons.notifications_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: onTap ?? () { debugPrint('Notifications tapped'); },
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: size * 0.55, color: iconColor),
          ),
        ),
        Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ),
      ],
    );
  }
}


