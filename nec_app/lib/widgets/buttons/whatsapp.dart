import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Circular WhatsApp-style send button with light green background and no shadow.
class WhatsAppButton extends StatefulWidget {
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

  /// How long each shake animation lasts.
  final Duration shakeDuration;

  /// How often the shake should occur (time between shakes).
  final Duration shakeInterval;

  /// Maximum rotation in radians for the shake.
  final double shakeAmplitude;

  const WhatsAppButton({
    super.key,
    this.onTap,
    this.size = 40,
    this.backgroundColor = const Color(0xFF25D366),
    this.iconColor = Colors.white,
    this.semanticLabel = 'Send on WhatsApp',
    this.assetPath = 'assets/images/whatsapp_logo.svg',
    this.shakeDuration = const Duration(milliseconds: 700),
    this.shakeInterval = const Duration(seconds: 2),
    this.shakeAmplitude = 0.18, // ~10 degrees
  });

  @override
  State<WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<WhatsAppButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.shakeDuration,
    );

    // A quick shake sequence: center -> left -> right -> left -> center
    _rotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -widget.shakeAmplitude).chain(CurveTween(curve: Curves.easeOut)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -widget.shakeAmplitude, end: widget.shakeAmplitude).chain(CurveTween(curve: Curves.easeInOut)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: widget.shakeAmplitude, end: -widget.shakeAmplitude / 2).chain(CurveTween(curve: Curves.easeInOut)), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -widget.shakeAmplitude / 2, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 1),
    ]).animate(_controller);

    _scheduleNextShake();
  }

  Future<void> _scheduleNextShake() async {
    while (!_isDisposed) {
      await Future.delayed(widget.shakeInterval);
      if (_isDisposed) break;
      try {
        await _controller.forward(from: 0);
      } catch (_) {
        // no-op if disposed mid-animation
      }
      if (_isDisposed) break;
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = widget.size * 0.60; // keep proportions similar to a FAB

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap ?? () { debugPrint('WhatsApp button tapped'); },
          customBorder: const CircleBorder(),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotation.value,
                  child: child,
                );
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
                child: SvgPicture.asset(
                  widget.assetPath,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


