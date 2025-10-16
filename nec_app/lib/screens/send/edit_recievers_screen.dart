import 'package:flutter/material.dart';
import 'package:nec_app/theme/theme_data.dart';

/// Demo UI that mirrors the provided "Edit receiver" mock.
/// This is a self-contained screen with local-only form state.
class EditRecieversScreen extends StatefulWidget {
  const EditRecieversScreen({super.key});

  @override
  State<EditRecieversScreen> createState() => _EditRecieversScreenState();
}

class _EditRecieversScreenState extends State<EditRecieversScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _firstNameController =
      TextEditingController(text: 'TEST');
  final TextEditingController _lastNameController =
      TextEditingController(text: 'AC');
  final TextEditingController _phoneController =
      TextEditingController(text: '01811445577');
  final TextEditingController _accountNoController =
      TextEditingController(text: '82451475524521');

  // Dropdown state
  String _relationship = 'BUSINESS CONTRACT';
  String _paymentMethod = 'ACCOUNT PAYEE';
  String _country = 'BANGLADESH';
  String _currency = 'TAKA BANGLADESH';
  String _service = 'BANGLADESH ALL BANK (ACCOUNT CREDIT)';
  String _bank = 'TRUST BANK LTD';
  String _accountType = 'SAVINGS';
  String? _branchCity; // optional
  String? _branchName; // optional

  // Demo lists (replace with API-backed sources later if needed)
  static const List<String> _relationshipOptions = <String>[
    'BUSINESS CONTRACT',
    'FAMILY',
    'FRIEND',
  ];

  static const List<String> _paymentMethods = <String>[
    'ACCOUNT PAYEE',
    'CASH PICKUP',
  ];

  static const List<String> _countries = <String>[
    'BANGLADESH',
    'INDIA',
    'NEPAL',
  ];

  static const List<String> _currencies = <String>[
    'TAKA BANGLADESH',
    'INR INDIA',
    'NPR NEPAL',
  ];

  static const List<String> _services = <String>[
    'BANGLADESH ALL BANK (ACCOUNT CREDIT)',
    'EXPRESS TRANSFER',
  ];

  static const List<String> _banks = <String>[
    'TRUST BANK LTD',
    'DHAKA BANK LTD',
    'DUTCH BANGLA BANK LTD',
  ];

  static const List<String> _accountTypes = <String>[
    'SAVINGS',
    'CURRENT',
  ];

  static const List<String> _branchCities = <String>[
    'Dhaka',
    'Chittagong',
    'Sylhet',
  ];

  static const List<String> _branchNames = <String>[
    'Banani Branch',
    'Gulshan Branch',
    'Motijheel Branch',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _accountNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Edit receiver'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: _buildTextField(_firstNameController, 'First name')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(_lastNameController, 'Last name')),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'BUSINESS CONTRACT',
                  value: _relationship,
                  items: _relationshipOptions,
                  onChanged: (String? v) => setState(() => _relationship = v ?? _relationship),
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'ACCOUNT PAYEE',
                  value: _paymentMethod,
                  items: _paymentMethods,
                  onChanged: (String? v) => setState(() => _paymentMethod = v ?? _paymentMethod),
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'BANGLADESH',
                  value: _country,
                  items: _countries,
                  onChanged: (String? v) => setState(() => _country = v ?? _country),
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'TAKA BANGLADESH',
                  value: _currency,
                  items: _currencies,
                  onChanged: (String? v) => setState(() => _currency = v ?? _currency),
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'BANGLADESH ALL BANK (ACCOUNT CREDIT)',
                  value: _service,
                  items: _services,
                  onChanged: (String? v) => setState(() => _service = v ?? _service),
                ),
                const SizedBox(height: 12),
                _buildTextField(_phoneController, 'Phone number', keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'TRUST BANK LTD',
                  value: _bank,
                  items: _banks,
                  onChanged: (String? v) => setState(() => _bank = v ?? _bank),
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'SAVINGS',
                  value: _accountType,
                  items: _accountTypes,
                  onChanged: (String? v) => setState(() => _accountType = v ?? _accountType),
                ),
                const SizedBox(height: 12),
                _buildTextField(_accountNoController, 'Account no', keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'Select Branch city',
                  value: _branchCity,
                  items: _branchCities,
                  isOptional: true,
                  onChanged: (String? v) => setState(() => _branchCity = v),
                ),
                const SizedBox(height: 12),
                _buildDropdown<String>(
                  label: 'Select Branch name',
                  value: _branchName,
                  items: _branchNames,
                  isOptional: true,
                  onChanged: (String? v) => setState(() => _branchName = v),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _onSubmit,
                    child: const Text('Update & Continue'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receiver updated (demo).')),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    bool isOptional = false,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items
          .map(
            (T e) => DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: _inputDecoration(label),
      validator: isOptional
          ? null
          : (T? v) {
              if (v == null) return 'Required';
              return null;
            },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.selected, width: 1.6),
      ),
    );
  }
}


