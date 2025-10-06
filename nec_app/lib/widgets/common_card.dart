import 'package:flutter/material.dart';

/// A highly reusable card container that standardizes visual styling
/// (elevation, rounded corners, borders) while remaining flexible.
///
/// Key capabilities:
/// - Optional `onTap` with ripple via InkWell
/// - Supports solid `color` or `gradient` backgrounds
/// - Shape/border customization via `borderRadius`, `borderColor`, `borderWidth`
/// - Content spacing with `padding` and outer `margin`
/// - Size control using `width`, `height`, and `constraints`
class CommonCard extends StatelessWidget {
  final Widget child;

  // Visual
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final Gradient? gradient;
  final Color? shadowColor;

  // Border
  final Color? borderColor;
  final double borderWidth;

  // Layout
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Clip clipBehavior;

  // Interaction
  final VoidCallback? onTap;
  final MouseCursor? mouseCursor;

  const CommonCard({
    super.key,
    required this.child,
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.color,
    this.gradient,
    this.shadowColor,
    this.borderColor,
    this.borderWidth = 0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
    this.mouseCursor,
  });

  @override
  Widget build(BuildContext context) {
    final ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: borderWidth > 0
          ? BorderSide(color: borderColor ?? Colors.grey.withOpacity(0.35), width: borderWidth)
          : BorderSide.none,
    );

    final bool useGradient = gradient != null;

    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // If gradient is used, paint it inside a Container. Keep Material transparent.
    if (useGradient) {
      content = Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
        ),
        child: content,
      );
    }

    // Add InkWell only if onTap is provided
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        customBorder: shape,
        mouseCursor: mouseCursor,
        child: content,
      );
    }

    Widget card = Material(
      color: useGradient ? Colors.transparent : (color ?? Theme.of(context).cardColor),
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      clipBehavior: clipBehavior,
      child: content,
    );

    if (width != null || height != null || constraints != null) {
      card = ConstrainedBox(
        constraints: constraints ?? const BoxConstraints(),
        child: SizedBox(width: width, height: height, child: card),
      );
    }

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}


