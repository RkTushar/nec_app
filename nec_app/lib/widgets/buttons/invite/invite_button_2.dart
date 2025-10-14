import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/models/country_model.dart';
import 'package:nec_app/screens/rewards/invite_screen.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/services/currency_prefs.dart';

class InviteButton2 extends StatefulWidget {
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
  State<InviteButton2> createState() => _InviteButton2State();
}

class _InviteButton2State extends State<InviteButton2> {
  String _symbol = '£';

  @override
  void initState() {
    super.initState();
    _resolveSymbol();
  }

  Future<void> _resolveSymbol() async {
    if (widget.currencyCode != null && widget.currencyCode!.trim().isNotEmpty) {
      setState(() => _symbol = CurrencyRepository.symbol(widget.currencyCode!.toUpperCase()));
      return;
    }
    final String? saved = await CurrencyPrefs.loadCurrencySymbol();
    if (saved != null && saved.isNotEmpty) {
      setState(() => _symbol = saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground = widget.backgroundColor ?? AppColors.primaryLight;
    final Color resolvedForeground = widget.foregroundColor ?? Colors.white;

    return SizedBox(
      height: 33,
      child: TextButton(
        onPressed: widget.onPressed ?? () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InviteScreen(currencyCode: widget.currencyCode),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: const Size(84, 33),
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedForeground,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            side: BorderSide(color: AppColors.primaryLight, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_symbol}5',
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


