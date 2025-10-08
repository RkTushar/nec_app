import 'package:flutter/material.dart';

/// A reusable TransactionCard widget for displaying transaction information.
///
/// This widget provides a consistent look and feel for transaction cards
/// with support for highlighting and customizable content.
class TransactionCard extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted ? const Color(0xFF1E88E5) : Theme.of(context).dividerColor,
          width: highlighted ? 2 : 1,
        ),
        boxShadow: highlighted
            ? <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF1E88E5).withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: avatarBorderColor ?? Colors.teal,
                width: 2,
              ),
            ),
            child: Icon(
              icon ?? Icons.person_outline_rounded,
              color: avatarIconColor ?? Colors.teal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor ?? const Color(0xFFD32F2F),
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
                dateText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                amountText,
                style: TextStyle(
                  color: amountColor ?? const Color(0xFFD32F2F),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
