import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'select_country_widget.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, String>? selectedCountryData;
  final ValueChanged<Map<String, String>?> onCountryChanged;
  final FormFieldValidator<String>? validator;
  final String? initialCountryCode;

  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.selectedCountryData,
    required this.onCountryChanged,
    this.validator,
    this.initialCountryCode,
  });

  Map<String, String>? _currentCountry() {
    return selectedCountryData ??
        SelectCountryField.getCountryByCode(initialCountryCode ?? '') ??
        SelectCountryField.getCountries().first;
  }

  String _dialCode() {
    final Map<String, String>? c = _currentCountry();
    final String dial = (c?['dial'] ?? '').toString();
    return dial.isNotEmpty ? '+$dial' : '';
  }

  String _flag() {
    final Map<String, String>? c = _currentCountry();
    return (c?['flag'] ?? '').toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: validator,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: '07XXXXXXXXXX',
        labelStyle: const TextStyle(color: Colors.black54),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_flag(), style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                _dialCode(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 36,
                child: VerticalDivider(
                  color: Colors.grey.withOpacity(0.35),
                  thickness: 1,
                  width: 1,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade500.withOpacity(0.35), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade500.withOpacity(0.35), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
