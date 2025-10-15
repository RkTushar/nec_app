import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/screens/history/transaction_details.dart';
import 'package:nec_app/models/transaction_model.dart';
import 'package:nec_app/services/currency_prefs.dart';

/// A reusable TransactionCard widget for displaying transaction information.
///
/// This widget provides a consistent look and feel for transaction cards
/// with support for highlighting and customizable content.
class TransactionCard extends StatefulWidget {
  /// The name of the person involved in the transaction
  final String name;

  /// The status text to display (e.g., "Status : Cancelled")
  final String statusText;

  /// The amount text to display (e.g., "BDT 10,000.00")
  final String amountText;

  /// The date text to display (e.g., "06-Nov-24 10:10 PM")
  final String dateText;

  /// Whether this transaction card should be highlighted
  final bool highlighted;

  /// The color of the status text (defaults to red for cancelled)
  final Color? statusColor;

  /// The color of the amount text (defaults to red)
  final Color? amountColor;

  /// The icon to display in the avatar circle
  final IconData? icon;

  /// The color of the avatar border
  final Color? avatarBorderColor;

  /// The color of the avatar icon
  final Color? avatarIconColor;

  /// Whether this card is considered selected by parent
  final bool selected;

  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Optional model to navigate with when onTap is not provided
  final TransactionModel? model;

  /// Bottom spacing added by default to separate cards
  final double bottomSpacing;

  const TransactionCard({
    super.key,
    required this.name,
    required this.statusText,
    required this.amountText,
    required this.dateText,
    this.highlighted = false,
    this.statusColor,
    this.amountColor,
    this.icon,
    this.avatarBorderColor,
    this.avatarIconColor,
    this.selected = false,
    this.onTap,
    this.bottomSpacing = 8.0,
    this.model,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _pressed = false;
  String _loginCurrencyCode = 'BDT';

  @override
  void initState() {
    super.initState();
    _loadLoginCurrencyCode();
  }

  Future<void> _loadLoginCurrencyCode() async {
    final String code = await CurrencyPrefs.loadSenderCurrencyCodeOrDefault('BDT');
    if (!mounted) return;
    setState(() => _loginCurrencyCode = code);
  }

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() {
      _pressed = pressed;
    });
  }

  Color _statusColorFor(String statusText) {
    final String normalized = statusText.toLowerCase();
    if (normalized.contains('done')) {
      return AppColors.primary; // primary green
    }
    if (normalized.contains('cancel')) {
      return const Color(0xFFD32F2F); // red
    }
    return const Color(0xFFD32F2F); // default red (backwards compatible)
  }

  double _parseAmountFromText(String txt) {
    // Extract decimal number from strings like "BDT 10,000.00"
    final match = RegExp(r"([0-9]+(?:,[0-9]{3})*(?:\.[0-9]+)?)").firstMatch(txt);
    if (match == null) return 0.0;
    return double.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Only show blue outline when the card is actively pressed (tap interaction)
    final bool isActive = _pressed;
    final Color borderColor = isActive ? const Color(0xFF1E88E5) : Colors.transparent;
    final double borderWidth = isActive ? 2.0 : 0.0;
    final List<BoxShadow>? activeShadow = isActive
        ? <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF1E88E5).withValues(alpha: 0.22),
              blurRadius: 10,
              spreadRadius: 0.5,
              offset: const Offset(0, 3),
            ),
          ]
        : null;
    final Color resolvedStatusColor = widget.statusColor ?? _statusColorFor(widget.statusText);
    final bool isDone = widget.statusText.toLowerCase().contains('done');
    final Color resolvedAmountColor = widget.amountColor ?? (isDone ? AppColors.primary : const Color(0xFFD32F2F));

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      // Keep outline through tap; we'll clear it after navigation in onTap
      onTapUp: (_) {},
      onTapCancel: () => _setPressed(false),
      onTap: () async {
        // Ensure the blue outline is visible briefly before navigating
        _setPressed(true);
        await Future.delayed(const Duration(milliseconds: 120));
        try {
          if (widget.onTap != null) {
            widget.onTap!.call();
          } else {
            if (!mounted) return;
            final TransactionModel model = widget.model ?? _inferModelFromProps();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TrackTransactionDemoScreen(transaction: model),
              ),
            );
          }
        } finally {
          // Allow a short time for route transition to start, then clear outline
          await Future.delayed(const Duration(milliseconds: 120));
          if (mounted) {
            _setPressed(false);
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: widget.bottomSpacing),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: activeShadow,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: widget.icon != null
                    ? Icon(
                        widget.icon!,
                        color: widget.avatarIconColor ?? AppColors.primary,
                        size: 24,
                      )
                    : SvgPicture.asset(
                        'assets/icons/person_icon.svg',
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          widget.avatarIconColor ?? AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.statusText,
                    style: TextStyle(
                      color: resolvedStatusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.dateText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  // Always show amount with login currency code
                  '${_loginCurrencyCode} ${widget.model != null
                          ? widget.model!.amount.toStringAsFixed(2)
                          : _parseAmountFromText(widget.amountText).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: resolvedAmountColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Best-effort construction of a TransactionModel from the card props so
  // the card can navigate standalone anywhere it's used.
  TransactionModel _inferModelFromProps() {
    double parseAmount(String txt) {
      // Extract decimal number from strings like "BDT 10,000.00"
      final match = RegExp(r"([0-9]+(?:,[0-9]{3})*(?:\.[0-9]+)?)").firstMatch(txt);
      if (match == null) return 0.0;
      return double.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0.0;
    }

    String currencyFrom(String txt) {
      // Get first 3-4 letters as currency if present
      final match = RegExp(r"^[A-Z]{3,4}").firstMatch(txt.trim());
      return match?.group(0) ?? 'BDT';
    }

    final String currency = currencyFrom(widget.amountText);
    final double receiverAmount = parseAmount(widget.amountText);
    final String status = widget.statusText.replaceFirst('Status : ', '').trim();

    return TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: widget.name,
      status: status.isEmpty ? 'Unknown' : status,
      amount: receiverAmount,
      date: DateTime.now(),
      highlighted: widget.highlighted,
      transactionNumber: 'GB${DateTime.now().millisecondsSinceEpoch % 10000000}/${DateTime.now().second.toString().padLeft(6, '0')}',
      receiverCurrency: currency,
      transferAmountGbp: 5.00,
      usedBalanceGbp: 0.00,
      paymentAmountGbp: 5.00,
      cardChargeGbp: 0.00,
      transferFeeGbp: 0.00,
      paymentStatusText: status.toLowerCase().contains('cancel') ? 'Cancelled' : 'In Hold (Mobile).',
      bankName: '',
    );
  }
}