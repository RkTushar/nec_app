import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/models/recievers_model.dart';
import 'package:nec_app/theme/theme_data.dart';

/// Reusable receiver card for the Send flow
class ReceiverCard extends StatefulWidget {
  final Receiver receiver;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const ReceiverCard({super.key, required this.receiver, this.margin = const EdgeInsets.only(bottom: 12), this.onEdit, this.onTap});

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard> {
  bool _pressed = false;
  final GlobalKey _editKey = GlobalKey();

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  bool _isInEdit(Offset globalPosition) {
    final RenderBox? box = _editKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;
    final Offset topLeft = box.localToGlobal(Offset.zero);
    final Size size = box.size;
    final Rect rect = topLeft & size;
    return rect.contains(globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = AppColors.textSecondary;
    final Color borderColor = _pressed ? AppColors.primary.withValues(alpha: 0.55) : Colors.transparent;
    final double borderWidth = _pressed ? 1.6 : 0.0;
    final List<BoxShadow>? shadows = _pressed
        ? <BoxShadow>[
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.18), blurRadius: 10, offset: const Offset(0, 3)),
          ]
        : const <BoxShadow>[
            BoxShadow(color: Color(0x0F000000), blurRadius: 6, offset: Offset(0, 2)),
          ];

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (TapDownDetails d) {
          if (_isInEdit(d.globalPosition)) return; // don't animate when tapping EDIT
          _setPressed(true);
        },
        onTapCancel: () => _setPressed(false),
        onTapUp: (TapUpDetails d) async {
          if (_isInEdit(d.globalPosition)) {
            _setPressed(false);
            return;
          }
          _setPressed(true);
          await Future.delayed(const Duration(milliseconds: 120));
          try {
            widget.onTap?.call();
          } finally {
            await Future.delayed(const Duration(milliseconds: 120));
            if (mounted) _setPressed(false);
          }
        },
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeInOut,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: shadows,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Top row: Avatar + Name/Number + EDIT button on the right
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 48,
                  height: 40,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      'assets/icons/person_icon.svg',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                      '${widget.receiver.firstName.toUpperCase()} ${widget.receiver.lastName.toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Text(widget.receiver.phoneNumber, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  key: _editKey,
                  onPressed: widget.onEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('EDIT', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Middle meta lines (full width below avatar)
            _dotLine(' ${widget.receiver.bank.name.toUpperCase()} (ACCOUNT CREDIT)', labelColor),
            const SizedBox(height: 2),
            Row(
              children: <Widget>[
                Text('ACCOUNT PAYEE', style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                _greenDot(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.receiver.bank.name.toUpperCase(),
                    style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Bottom row: Country left, ACTIVE right aligned with country
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.receiver.country.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const Text('ACTIVE', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
          ),
          ),
        ),
      ),
    );
  }

  static Widget _greenDot() => const CircleAvatar(radius: 4, backgroundColor: AppColors.success);

  static Widget _dotLine(String text, Color labelColor) {
    return Row(
      children: <Widget>[
        _greenDot(),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.trim(),
            style: TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}


