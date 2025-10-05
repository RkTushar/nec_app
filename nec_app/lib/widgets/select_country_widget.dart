// Path: widgets/select_country_widget.dart

import 'package:flutter/material.dart';

class SelectCountryField extends StatelessWidget {
  final Map<String, String>? selectedCountryData;
  final ValueChanged<Map<String, String>?> onChanged;
  final FormFieldValidator<Map<String, String>?>? validator;
  final String? initialCountryCode;
  final bool showDialCode;
  final bool readOnly;
  final bool showDropdownIcon;

  const SelectCountryField({
    super.key,
    required this.selectedCountryData,
    required this.onChanged,
    this.validator,
    this.initialCountryCode,
    this.showDialCode = false,
    this.readOnly = false,
    this.showDropdownIcon = true,
  });

  // The list of countries is an internal, static property.
  static final List<Map<String, String>> _countries = <Map<String, String>>[
    {'code': 'ZA', 'name': 'South Africa', 'flag': '🇿🇦', 'dial': '27'},
    {'code': 'US', 'name': 'United States', 'flag': '🇺🇸', 'dial': '1'},
    {'code': 'IN', 'name': 'India', 'flag': '🇮🇳', 'dial': '91'},
    {'code': 'JP', 'name': 'Japan', 'flag': '🇯🇵', 'dial': '81'},
    {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧', 'dial': '44'},
  ];

  // Expose the country list via a static getter for other widgets to use.
  static List<Map<String, String>> getCountries() => _countries;

  // A helper to find the country data from a code.
  static Map<String, String>? getCountryByCode(String code) {
    try {
      return _countries.firstWhere(
        (c) => (c['code'] ?? '').toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);

    // Determine the current value.
    final Map<String, String>? currentValue =
        selectedCountryData ??
        SelectCountryField.getCountryByCode(initialCountryCode ?? '');

    final Widget prefixIcon = currentValue != null
        ? Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: Text(
                  currentValue['flag'] ?? '',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          )
        : const Icon(Icons.flag_outlined, color: Colors.grey);

    final InputDecoration dropdownDecoration = InputDecoration(
      labelText: 'Select from country',
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIcon: prefixIcon,
      suffixIcon: showDropdownIcon
          ? const Icon(Icons.arrow_drop_down, color: Colors.black54)
          : const SizedBox.shrink(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide(color: Colors.grey.shade500.withOpacity(0.35), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide(color: Colors.grey.shade500.withOpacity(0.35), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );

    String dialFor(Map<String, String> c) {
      final String dialFromValue = (c['dial'] ?? '').toString();
      if (dialFromValue.isNotEmpty) return dialFromValue;
      final String code = (c['code'] ?? '').toString();
      final Map<String, String>? found = getCountryByCode(code);
      return (found?['dial'] ?? '').toString();
    }

    String display(Map<String, String> c) =>
        showDialCode ? '+${dialFor(c)}' : (c['name'] ?? '');

    return DropdownButtonFormField<Map<String, String>>(
      decoration: dropdownDecoration,
      initialValue: currentValue,
      hint: const Text('Select from country'),
      isExpanded: true,
      dropdownColor: Colors.white,
      items: SelectCountryField.getCountries().map((
        Map<String, String> country,
      ) {
        return DropdownMenuItem<Map<String, String>>(
          value: country,
          child: Row(
            children: <Widget>[
              Text(country['flag'] ?? '', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  (country['name'] ?? '').toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      selectedItemBuilder: (_) =>
          SelectCountryField.getCountries().map((Map<String, String> country) {
            final String name = (country['name'] ?? '').toUpperCase();
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
      onChanged: readOnly ? null : onChanged,
      disabledHint: currentValue != null ? Text(display(currentValue)) : null,
      validator: validator,
      icon: showDropdownIcon
          ? const Icon(Icons.arrow_drop_down, color: Colors.black54)
          : const SizedBox.shrink(),
    );
  }
}
