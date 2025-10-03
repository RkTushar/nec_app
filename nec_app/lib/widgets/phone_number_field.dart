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

  Future<void> _openCountryPicker(BuildContext context) async {
    final List<Map<String, String>> countries = SelectCountryField.getCountries();
    final Map<String, String>? picked = await showModalBottomSheet<Map<String, String>>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext ctx) {
        return ListView.separated(
          itemCount: countries.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, int index) {
            final Map<String, String> c = countries[index];
            return ListTile(
              leading: Text(c['flag'] ?? '', style: const TextStyle(fontSize: 22)),
              title: Text(c['name'] ?? ''),
              trailing: Text('+${c['dial'] ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => Navigator.of(ctx).pop(c),
            );
          },
        );
      },
    );
    if (picked != null) {
      onCountryChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      height: 52,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () => _openCountryPicker(context),
            child: Padding(
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
                ],
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: VerticalDivider(
              color: Colors.grey.shade300,
              thickness: 1,
              width: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              validator: validator,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: '07XXXXXXXXXX',
                hintStyle: TextStyle(color: Colors.black45),
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}


