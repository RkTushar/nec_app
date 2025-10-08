import 'package:flutter/material.dart';

/// A reusable Card widget with consistent styling.
///
/// It provides a common look and feel for different sections of the UI
/// by wrapping the child widget in a Card with predefined elevation,
/// shape, and padding.
class CommonCard extends StatelessWidget {
  /// The widget to be displayed inside the card.
  final Widget child;

  const CommonCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}