// lib/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.inputFormatters,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(prefixIcon, color: Colors.grey),
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
              keyboardType: keyboardType,
              validator: validator,
              autovalidateMode: autovalidateMode,
              readOnly: readOnly,
              onTap: onTap,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                hintText: labelText,
                hintStyle: const TextStyle(color: Colors.black45),
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          if (suffixIcon != null) ...<Widget>[
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(suffixIcon, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}
