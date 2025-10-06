import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Dummy exchange rates relative to a base currency (USD = 1.0)
const Map<String, double> _exchangeRates = {
  'USD': 1.0,
  'EUR': 0.93, // 1 USD = 0.93 EUR
  'GBP': 0.81, // 1 USD = 0.81 GBP
  'JPY': 150.0, // 1 USD = 150 JPY
  'CAD': 1.36, // 1 USD = 1.36 CAD
  'AUD': 1.50, // 1 USD = 1.50 AUD
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

  // Selected currencies, initialized to default values
  String? _sendCurrency = 'USD';
  String? _receiveCurrency = 'EUR';

  // Flag to prevent an infinite loop during two-way updates
  bool _isConverting = false;

  @override
  void initState() {
    super.initState();
    // Attach listeners to trigger conversion when text changes
    _sendController.addListener(_onSendAmountChanged);
    _receiveController.addListener(_onReceiveAmountChanged);
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
    // If the change was programmatic (from the other controller), stop
    if (_isConverting) return;

    _convertCurrency(
      sourceController: _sendController,
      targetController: _receiveController,
      sourceCurrency: _sendCurrency,
      targetCurrency: _receiveCurrency,
    );
  }

  void _onReceiveAmountChanged() {
    // If the change was programmatic (from the other controller), stop
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
    // 1. Set flag to true to prevent the other controller's listener from running
    _isConverting = true;

    try {
      if (sourceCurrency == null || targetCurrency == null) {
        targetController.text = '';
        return;
      }
      
      // If the currencies are the same, just mirror the value
      if (sourceCurrency == targetCurrency) {
        targetController.text = sourceController.text;
        return;
      }

      final sourceRate = _exchangeRates[sourceCurrency];
      final targetRate = _exchangeRates[targetCurrency];

      if (sourceRate == null || targetRate == null) {
        targetController.text = 'Rate Error';
        return;
      }

      final sourceText = sourceController.text.trim();
      final sourceAmount = double.tryParse(sourceText);

      // If input is empty or invalid, clear the output field
      if (sourceAmount == null || sourceAmount <= 0) {
        targetController.text = '';
        return;
      }

      // Formula: TargetAmount = (SourceAmount / SourceRate) * TargetRate
      // The rates are relative to USD (base = 1.0)
      final targetAmount = (sourceAmount / sourceRate) * targetRate;

      // Update the target controller text, formatted to 2 decimal places
      targetController.text = targetAmount.toStringAsFixed(2);

    } catch (e) {
      targetController.text = 'Error';
    } finally {
      // 2. Always reset the flag after the update is done
      _isConverting = false;
    }
  }

  // --- UI Builder Methods ---

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Currency Converter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // Send Row
          Text('You Send', style: TextStyle(fontSize: 16, color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildRow(
            controller: _sendController,
            value: _sendCurrency,
            onChanged: (v) {
              setState(() {
                _sendCurrency = v;
                // Recalculate if the currency changes and there's an amount
                _onSendAmountChanged(); 
              });
            },
            hintText: 'Enter amount to send',
          ),
          
          // Swap Button
          Center(
            child: IconButton(
              icon: const Icon(Icons.swap_vert, size: 36, color: Colors.grey),
              onPressed: _swapCurrencies,
            ),
          ),

          // Receive Row
          Text('You Receive', style: TextStyle(fontSize: 16, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildRow(
            controller: _receiveController,
            value: _receiveCurrency,
            onChanged: (v) {
              setState(() {
                _receiveCurrency = v;
                // Recalculate if the currency changes and there's an amount
                _onSendAmountChanged(); // We assume the user is trying to calculate from the send side after swapping currency
              });
            },
            hintText: 'Converted amount will appear here',
          ),
        ],
      ),
    );
  }

  void _swapCurrencies() {
    setState(() {
      // Swap the selected currencies
      final tempCurrency = _sendCurrency;
      _sendCurrency = _receiveCurrency;
      _receiveCurrency = tempCurrency;

      // Swap the amounts
      final tempAmount = _sendController.text;
      _sendController.text = _receiveController.text;
      _receiveController.text = tempAmount;
      
      // Perform a final conversion to ensure consistency (e.g., if one field was empty)
      _onSendAmountChanged();
    });
  }


  Widget _buildRow({
    required TextEditingController controller,
    required String? value,
    required ValueChanged<String?> onChanged,
    required String hintText,
  }) {
    // Generate DropdownMenuItem list from the dummy data keys
    final List<DropdownMenuItem<String>> currencyItems = _exchangeRates.keys
        .map((String key) => DropdownMenuItem<String>(
              value: key,
              child: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
            ))
        .toList();

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: <Widget>[
            // Input Field
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Allows numbers and a single decimal point/comma
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.\,]?\d*')),
                ],
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Separator Line
            Container(
              height: 40,
              width: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 8),
            // Currency Dropdown
            Container(
              constraints: const BoxConstraints(minWidth: 80),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isDense: true,
                  onChanged: onChanged,
                  items: currencyItems,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
