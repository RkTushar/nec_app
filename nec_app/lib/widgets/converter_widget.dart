import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Dummy exchange rates relative to a base currency (USD = 1.0)
// Tuned so that 1 GBP ≈ 164.20 BDT for demo purposes
const Map<String, double> _exchangeRates = {
  'USD': 1.0,
  'EUR': 0.93, // 1 USD = 0.93 EUR
  'GBP': 0.81, // 1 USD = 0.81 GBP
  'BDT': 132.00, // 1 USD = 132.00 BDT -> 1 GBP ≈ 164.20 BDT
  'JPY': 150.0, // 1 USD = 150 JPY
  'CAD': 1.36, // 1 USD = 1.36 CAD
  'AUD': 1.50, // 1 USD = 1.50 AUD
};

const Map<String, String> _currencyFlags = {
  'USD': '🇺🇸',
  'EUR': '🇪🇺',
  'GBP': '🇬🇧',
  'BDT': '🇧🇩',
  'JPY': '🇯🇵',
  'CAD': '🇨🇦',
  'AUD': '🇦🇺',
};

const Map<String, String> _currencySymbols = {
  'USD': r'$',
  'EUR': '€',
  'GBP': '£',
  'BDT': 'BDT',
  'JPY': '¥',
  'CAD': 'C\$',
  'AUD': 'A\$',
};

class ConverterWidget extends StatefulWidget {
  const ConverterWidget({super.key});

  @override
  State<ConverterWidget> createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<ConverterWidget> {
  // Text controllers for the input fields
  final TextEditingController _sendController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();

  // Selected currencies, initialized to match the provided UI
  String? _sendCurrency = 'GBP';
  String? _receiveCurrency = 'BDT';

  // Flag to prevent an infinite loop during two-way updates
  bool _isConverting = false;

  @override
  void initState() {
    super.initState();
    // Attach listeners to trigger conversion when text changes
    _sendController.addListener(_onSendAmountChanged);
    _receiveController.addListener(_onReceiveAmountChanged);
    // Prefill demo value and compute initial conversion
    _sendController.text = '100';
    _onSendAmountChanged();
  }

  @override
  void dispose() {
    // Remove listeners and dispose controllers
    _sendController.removeListener(_onSendAmountChanged);
    _receiveController.removeListener(_onReceiveAmountChanged);
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }

  // --- Change Handlers ---

  void _onSendAmountChanged() {
    if (_isConverting) return;
    _convertCurrency(
      sourceController: _sendController,
      targetController: _receiveController,
      sourceCurrency: _sendCurrency,
      targetCurrency: _receiveCurrency,
    );
  }

  void _onReceiveAmountChanged() {
    if (_isConverting) return;
    _convertCurrency(
      sourceController: _receiveController,
      targetController: _sendController,
      sourceCurrency: _receiveCurrency,
      targetCurrency: _sendCurrency,
    );
  }

  // --- Conversion Logic ---

  void _convertCurrency({
    required TextEditingController sourceController,
    required TextEditingController targetController,
    required String? sourceCurrency,
    required String? targetCurrency,
  }) {
    _isConverting = true;
    try {
      if (sourceCurrency == null || targetCurrency == null) {
        targetController.text = '';
        return;
      }
      if (sourceCurrency == targetCurrency) {
        targetController.text = sourceController.text;
        return;
      }
      final double? sourceRate = _exchangeRates[sourceCurrency];
      final double? targetRate = _exchangeRates[targetCurrency];
      if (sourceRate == null || targetRate == null) {
        targetController.text = '';
        return;
      }
      final String sourceText = sourceController.text.trim();
      final double? sourceAmount = double.tryParse(sourceText);
      if (sourceAmount == null || sourceAmount <= 0) {
        targetController.text = '';
        return;
      }
      final double targetAmount = (sourceAmount / sourceRate) * targetRate;
      targetController.text = targetAmount.toStringAsFixed(2);
    } finally {
      _isConverting = false;
      setState(() {}); // update rate line when values/currency change
    }
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final Color dividerColor = Colors.grey.shade300;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildLabeledRow(
          label: 'Send',
          controller: _sendController,
          value: _sendCurrency,
          onChanged: (v) {
            setState(() {
              _sendCurrency = v;
              _onSendAmountChanged();
            });
          },
          hintText: '100',
        ),
        Container(height: 1, color: dividerColor, margin: const EdgeInsets.symmetric(horizontal: 4)),
        _buildLabeledRow(
          label: 'Receive',
          controller: _receiveController,
          value: _receiveCurrency,
          onChanged: (v) {
            setState(() {
              _receiveCurrency = v;
              _onSendAmountChanged();
            });
          },
          hintText: '—',
        ),
        const SizedBox(height: 12),
        _buildRateLine(),
      ],
    );
  }

  Widget _buildLabeledRow({
    required String label,
    required TextEditingController controller,
    required String? value,
    required ValueChanged<String?> onChanged,
    required String hintText,
    bool readOnly = false,
  }) {
    final List<DropdownMenuItem<String>> currencyItems = _exchangeRates.keys
        .map((String key) => DropdownMenuItem<String>(
              value: key,
              child: Row(
                children: <Widget>[
                  Text(_currencyFlags[key] ?? '', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 18),
                  ),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(height: 32, width: 1, color: Colors.grey.shade300),
              const SizedBox(width: 10),
              SizedBox(
                width: 140,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isDense: true,
                    onChanged: onChanged,
                    items: currencyItems,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: Colors.black54),
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRateLine() {
    final String from = _sendCurrency ?? '';
    final String to = _receiveCurrency ?? '';
    final double? sourceRate = _exchangeRates[from];
    final double? targetRate = _exchangeRates[to];
    if (sourceRate == null || targetRate == null) return const SizedBox.shrink();
    final double perOne = (1.0 / sourceRate) * targetRate;
    final String fromSymbol = _currencySymbols[from] ?? from;
    final String toSymbol = _currencySymbols[to] ?? to;
    return Center(
      child: Text(
        '$fromSymbol 1.00= $toSymbol ${perOne.toStringAsFixed(2)}',
        style: const TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.w800, fontSize: 18),
      ),
    );
  }
}
