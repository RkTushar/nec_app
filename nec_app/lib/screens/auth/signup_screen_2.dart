import 'package:flutter/material.dart';
import 'package:nec_app/widgets/custom_datepicker.dart';

// Assuming these are your custom widgets
import '../../widgets/back_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/password_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/select_country_widget.dart';
import '../../widgets/phone_number_field.dart';

const Color _primaryGreen = Color(0xFF4CAF50);

class SignupScreen2 extends StatefulWidget {
  final String? initialCountryCode;
  const SignupScreen2({super.key, this.initialCountryCode});

  @override
  State<SignupScreen2> createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<SignupScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String>? _selectedCountry;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  bool _hasReferral = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _pickDateOfBirth() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomDatePicker(
          initialDate: _dobController.text.isNotEmpty
              ? DateTime.tryParse(
                  _dobController.text.split('/').reversed.join('-'),
                )
              : null,
          onDateSelected: (DateTime selectedDate) {
            _dobController.text =
                '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().padLeft(4, '0')}';
          },
        );
      },
    );
  }

  void _submitForm() {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept Terms and Conditions')),
        );
        return;
      }

      final Map<String, String>? country =
          _selectedCountry ??
          SelectCountryField.getCountryByCode(widget.initialCountryCode ?? '');
      final String dial = country?['dial'] ?? '';
      final String local = _phoneController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      final String fullPhone = dial.isNotEmpty ? '+$dial$local' : local;
      debugPrint('Submitting phone: $fullPhone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 12),
                const Text(
                  'Create a Nec Money Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter your information',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Country code + phone number
                PhoneNumberField(
                  controller: _phoneController,
                  selectedCountryData: _selectedCountry,
                  initialCountryCode: widget.initialCountryCode,
                  onCountryChanged: (Map<String, String>? value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone is required';
                    }
                    if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 7) {
                      return 'Enter a valid phone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email address',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final RegExp emailRegex = RegExp(r'^\S+@\S+\.\S+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // New Password
                PasswordTextField(
                  controller: _passwordController,
                  labelText: 'New password',
                  // no leading icon per request
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'At least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password
                PasswordTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm password',
                  // no leading icon per request
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Date of Birth
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDateOfBirth,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Date of Birth is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'DD / MM / YYYY',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(
                      Icons.calendar_month,
                      color: Colors.grey,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: const BorderSide(
                        color: _primaryGreen,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 12),

                // Referral toggle (aligned with terms row)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _hasReferral,
                        activeColor: _primaryGreen,
                        onChanged: (bool? value) {
                          setState(() {
                            _hasReferral = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Do you have referral code',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                if (_hasReferral) ...<Widget>[
                  CustomTextField(
                    controller: _referralController,
                    labelText: 'Add referral code',
                    prefixIcon: Icons.card_giftcard_outlined,
                    validator: (value) {
                      if (_hasReferral &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Referral code required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Terms checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptedTerms,
                        activeColor: _primaryGreen,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          children: <InlineSpan>[
                            const TextSpan(text: 'I accepted the '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                ),
                                onPressed: () {
                                  // TODO: Navigate to Terms and Conditions
                                },
                                child: const Text(
                                  'Terms and Conditions',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                ),
                                onPressed: () {
                                  // TODO: Navigate to Privacy Policy
                                },
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' and find out our new Services and exclusive offers via Email, SMS or Call.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Continue button
                PrimaryButton(label: 'Continue', onPressed: _submitForm),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
