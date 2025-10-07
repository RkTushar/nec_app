// Path: widgets/select_country_widget.dart

import 'package:flutter/material.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/models/country_model.dart';

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

  // Cache country maps so DropdownButton values match item identities.
  static final List<Map<String, String>> _countriesCache =
      CountryRepository.getAll().map((Country c) => c.toMap()).toList();

  // Expose the country list via a static getter for other widgets to use.
  static List<Map<String, String>> getCountries() => _countriesCache;

  // A helper to find the country data from a code.
  static Map<String, String>? getCountryByCode(String code) {
    try {
      return _countriesCache.firstWhere(
        (Map<String, String> c) => (c['code'] ?? '').toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use themed colors via Theme.of(context) directly below

    // Determine the current value.
    Map<String, String>? currentValue;
    if (selectedCountryData != null) {
      final String code = (selectedCountryData!['code'] ?? '').toString();
      currentValue = SelectCountryField.getCountryByCode(code) ?? selectedCountryData;
    } else {
      currentValue = SelectCountryField.getCountryByCode(initialCountryCode ?? '');
    }

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
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      prefixIcon: prefixIcon,
      suffixIcon: showDropdownIcon
          ? const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary)
          : const SizedBox.shrink(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.card,
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
      dropdownColor: AppColors.card,
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
                    color: AppColors.textPrimary,
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
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
      onChanged: readOnly ? null : onChanged,
      disabledHint: currentValue != null ? Text(display(currentValue)) : null,
      validator: validator,
      icon: showDropdownIcon
          ? const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary)
          : const SizedBox.shrink(),
    );
  }
}
