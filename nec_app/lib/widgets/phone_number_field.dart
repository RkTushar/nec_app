import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'select_country_widget.dart';

const Color _primaryGreen = Color(0xFF4CAF50);

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

  InputDecoration _phoneDecoration() {
    return InputDecoration(
      hintText: '07XXXXXXXXXX',
      hintStyle: const TextStyle(color: Colors.black45),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: _primaryGreen, width: 2.0),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: SelectCountryField(
            selectedCountryData: selectedCountryData,
            onChanged: onCountryChanged,
            initialCountryCode: initialCountryCode,
            showDialCode: true,
            readOnly: true,
            showDropdownIcon: false,
            validator: (value) {
              if (value == null || (value['code'] ?? '').isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 8,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            validator: validator,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: _phoneDecoration(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}


