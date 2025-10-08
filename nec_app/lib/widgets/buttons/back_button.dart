import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Color iconColor;
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.iconColor = Colors.black, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, color: iconColor),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}


