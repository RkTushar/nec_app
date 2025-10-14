import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nec_app/models/country_model.dart';
import 'package:nec_app/services/currency_prefs.dart';

// Rates, flags and currency listing now sourced from CurrencyRepository.

class _ReceiverCountry {
  final String name;
  final String currency;
  final String flag;
  const _ReceiverCountry(this.name, this.currency, this.flag);
}

List<_ReceiverCountry> _buildReceiverCountries() {
  final List<Country> countries = CurrencyRepository.defaultReceiverCountries();
  return countries
      .map((Country c) => _ReceiverCountry(c.name, c.currencyCode, c.flag))
      .toList();
}

class SendReceiveConverter extends StatefulWidget {
  final String? initialSenderCurrency; // e.g., 'GBP'
  final double? initialAmount; // e.g., 100.0
  const SendReceiveConverter({super.key, this.initialSenderCurrency, this.initialAmount});

  @override
  State<SendReceiveConverter> createState() => _SendReceiveConverterState();
}

class _SendReceiveConverterState extends State<SendReceiveConverter> {
  final TextEditingController _sendCtrl = TextEditingController(text: '0.00');
  final TextEditingController _recvCtrl = TextEditingController(text: '0.00');

  String _sendCurrency = 'GBP';
  late List<_ReceiverCountry> _receiverCountries;
  late _ReceiverCountry _receiver;
  bool _isConverting = false;

  @override
  void initState() {
    super.initState();
    _receiverCountries = _buildReceiverCountries();
    _receiver = _receiverCountries.first;
    // Initialize sender currency and amount based on inputs or persisted value
    _initCurrencyAndAmount();
    _sendCtrl.addListener(_onSendChanged);
    _recvCtrl.addListener(_onRecvChanged);
  }

  @override
  void dispose() {
    _sendCtrl.removeListener(_onSendChanged);
    _recvCtrl.removeListener(_onRecvChanged);
    _sendCtrl.dispose();
    _recvCtrl.dispose();
    super.dispose();
  }

  Future<void> _initCurrencyAndAmount() async {
    final String? incomingCurrency = (widget.initialSenderCurrency ?? '').isNotEmpty
        ? widget.initialSenderCurrency
        : null;

    // Prefer incoming currency, otherwise load last saved, else keep default 'GBP'
    if (incomingCurrency != null) {
      _sendCurrency = incomingCurrency;
      await _saveLastSenderCurrency(_sendCurrency);
    } else {
      final String? saved = await _loadLastSenderCurrency();
      if ((saved ?? '').isNotEmpty) {
        _sendCurrency = saved!;
      }
    }

    if ((widget.initialAmount ?? 0) > 0) {
      _sendCtrl.text = widget.initialAmount!.toStringAsFixed(2);
    }

    if (mounted) {
      // Trigger initial conversion if we have an amount
      if (_sendCtrl.text.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _onSendChanged());
      }
      setState(() {});
    }
  }

  Future<void> _saveLastSenderCurrency(String code) async {
    try {
      await CurrencyPrefs.saveSenderCurrencyCode(code);
    } catch (_) {
      // Intentionally ignore persistence errors
    }
  }

  Future<String?> _loadLastSenderCurrency() async {
    try {
      return CurrencyPrefs.loadSenderCurrencyCode();
    } catch (_) {
      return null;
    }
  }

  void _onSendChanged() {
    if (_isConverting) return;
    _convert(source: _sendCtrl, target: _recvCtrl, from: _sendCurrency, to: _receiver.currency);
  }

  void _onRecvChanged() {
    if (_isConverting) return;
    _convert(source: _recvCtrl, target: _sendCtrl, from: _receiver.currency, to: _sendCurrency);
  }

  void _convert({
    required TextEditingController source,
    required TextEditingController target,
    required String from,
    required String to,
  }) {
    _isConverting = true;
    try {
    final double? fromRate = CurrencyRepository.rate(from);
    final double? toRate = CurrencyRepository.rate(to);
      if (fromRate == null || toRate == null) return;
      final double? amount = double.tryParse(source.text.replaceAll(',', '.'));
      if (amount == null) return;
      final double result = (amount / fromRate) * toRate;
      target.text = result.toStringAsFixed(2);
      setState(() {});
    } finally {
      _isConverting = false;
    }
  }

  double _ratePerOne(String from, String to) {
    final double? fr = CurrencyRepository.rate(from);
    final double? tr = CurrencyRepository.rate(to);
    if (fr == null || tr == null) return 0.0;
    return (1.0 / fr) * tr;
  }

  void _openReceiverPicker() async {
    final _ReceiverCountry? picked = await showModalBottomSheet<_ReceiverCountry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              const Text('Select Receiver Country', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _receiverCountries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (BuildContext _, int i) {
                    final _ReceiverCountry c = _receiverCountries[i];
                    return ListTile(
                      leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                      title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Text(c.currency, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                      onTap: () => Navigator.of(ctx).pop(c),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      setState(() => _receiver = picked);
      _onSendChanged();
    }
  }

  // void _swapCurrencies() {
  //   setState(() {
  //     final String oldSend = _sendCurrency;
  //     _sendCurrency = _receiver.currency;
  //     final _ReceiverCountry newReceiver = _receiverCountries.firstWhere(
  //       (c) => c.currency == oldSend,
  //       orElse: () => _receiver,
  //     );
  //     _receiver = newReceiver;
  //   });
  //   final String tmp = _sendCtrl.text;
  //   _sendCtrl.text = _recvCtrl.text;
  //   _recvCtrl.text = tmp;
  //   _onSendChanged();
  // }

  @override
  Widget build(BuildContext context) {
    final Color dividerColor = Colors.grey.shade300;
    final double rate = _ratePerOne(_sendCurrency, _receiver.currency);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Top country pill with rate
        InkWell(
          onTap: _openReceiverPicker,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: dividerColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                Text(_receiver.flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_receiver.name}  1 $_sendCurrency = ${rate.toStringAsFixed(2)} ${_receiver.currency}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Left: Send
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(CurrencyRepository.flag(_sendCurrency), style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(_sendCurrency, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _sendCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                    ],
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Container(height: 1, color: dividerColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: dividerColor),
                ),
                child: const Icon(Icons.sync_alt_rounded, color: Colors.black87),
              ),
            ),
            // Right: Receive
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(_receiver.flag, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(_receiver.currency, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _recvCtrl,
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                    ],
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Container(height: 1, color: dividerColor),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}


