import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/models/country_model.dart';

class InviteButton2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? currencyCode; // ISO 4217 code e.g. GBP, USD

  const InviteButton2({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final Color resolvedForeground = foregroundColor ?? Colors.white;
    final String code = (currencyCode == null || currencyCode!.trim().isEmpty) ? 'GBP' : currencyCode!.toUpperCase();
    final String symbol = CurrencyRepository.symbol(code);

    return SizedBox(
      height: 33,
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
            Text(
              '${symbol}5',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            ColorFiltered(
              colorFilter: ColorFilter.mode(resolvedForeground, BlendMode.srcIn),
              child: SvgPicture.asset('assets/icons/gift_icon.svg', width: 20, height: 20),
            ),
          ],
        ),
      ),
    );
  }
}


