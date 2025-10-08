import 'package:flutter/material.dart';

// Assuming these are your custom widgets
import '../../widgets/buttons/back_button.dart';
import '../../widgets/fields/custom_text_field.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/fields/select_country_widget.dart';
import '../../widgets/fields/custom_datepicker.dart';

// Define the main color from the image (a shade of green)
const Color _primaryGreen = Color(0xFF4CAF50);

class ForgotPasswordScreen extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String>? _selectedCountryData;
  DateTime? _selectedDob;

  bool get _isFormValid {
    final String email = _emailController.text.trim();
    return email.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    if ((widget.initialEmail ?? '').isNotEmpty) {
      _emailController.text = widget.initialEmail!.trim();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Manually trigger form validation only when the button is pressed
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      // TODO: Implement password reset logic (e.g., send link/code to email)

      // For demonstration, navigate to a confirmation screen or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reset link sent to ${_emailController.text}'),
          backgroundColor: _primaryGreen,
        ),
      );
      // Optional: Navigate back to the login screen after a delay
    }
  }

  Future<void> _pickDob() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CustomDatePicker(
          initialDate: _selectedDob,
          onDateSelected: (DateTime date) {
            setState(() {
              _selectedDob = date;
              _dobController.text =
                  '${date.day.toString().padLeft(2, '0')} / '
                  '${date.month.toString().padLeft(2, '0')} / '
                  '${date.year.toString()}';
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        leading: const AppBackButton(),
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            // Validate only fields that opt-in; others remain manual.
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),

                // 1. Header Text
                const Text(
                  'Reset password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Subtitle/Instructions
                const Text(
                  'Please enter your login email and date of birth for reset password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Country selector
                SelectCountryField(
                  selectedCountryData: _selectedCountryData,
                  onChanged: (Map<String, String>? newValue) {
                    setState(() {
                      _selectedCountryData = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || (value['code'] ?? '').isEmpty) {
                      return 'Country is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. Email Input Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final RegExp emailRegex = RegExp(r'^\S+@\S+\.\S+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  // Update button state as user types
                  // ignore: no_leading_underscores_for_local_identifiers
                ),
                const SizedBox(height: 16),

                // 5. Date of Birth (DD / MM / YYYY)
                CustomTextField(
                  controller: _dobController,
                  labelText: 'Date of Birth (DD / MM / YYYY)',
                  // prefixIcon: Icons.cake_outlined,
                  readOnly: true,
                  onTap: _pickDob,
                  validator: (value) {
                    if ((_selectedDob == null) ||
                        (value == null || value.isEmpty)) {
                      return 'Date of birth is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // 6. Reset Button
                PrimaryButton(
                  label: 'Reset password',
                  onPressed: _isFormValid ? _submitForm : null,
                  enabled: _isFormValid,
                ),
                const SizedBox(height: 40),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
