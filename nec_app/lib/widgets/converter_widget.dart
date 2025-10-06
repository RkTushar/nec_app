import 'package:flutter/material.dart';

class ConverterWidget extends StatefulWidget {
  const ConverterWidget({super.key});

  @override
  State<ConverterWidget> createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<ConverterWidget> {
  final TextEditingController _sendController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();

  String? _sendCurrency;
  String? _receiveCurrency;

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildRow(
          controller: _sendController,
          value: _sendCurrency,
          onChanged: (v) => setState(() => _sendCurrency = v),
        ),
        const SizedBox(height: 12),
        _buildRow(
          controller: _receiveController,
          value: _receiveCurrency,
          onChanged: (v) => setState(() => _receiveCurrency = v),
        ),
      ],
    );
  }

  Widget _buildRow({
    required TextEditingController controller,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            constraints: const BoxConstraints(minWidth: 80),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isDense: true,
                onChanged: onChanged,
                items: const <DropdownMenuItem<String>>[],
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


