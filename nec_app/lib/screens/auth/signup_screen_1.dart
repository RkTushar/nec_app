import 'package:flutter/material.dart';
import '../../widgets/select_country_widget.dart'; // Import the country widget
import '../../widgets/custom_text_field.dart';
import '../../widgets/back_button.dart';
import '../../widgets/primary_button.dart';
import 'login_screen.dart';
import 'signup_screen_2.dart';

// Define the main color from the image (a shade of green)
const Color primaryGreen = Color(0xFF4CAF50);

class SignupScreen1 extends StatefulWidget {
  const SignupScreen1({super.key});

  @override
  State<SignupScreen1> createState() => _SignupScreen1State();
}

class _SignupScreen1State extends State<SignupScreen1> {
  // State variable to hold the selected country data
  Map<String, String>? _selectedCountryData;

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Custom route transition for right-to-left sliding animation
  Route _createRightToLeftRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the transition from right (1.0) to left (0.0)
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease; // A standard, smooth transition curve

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
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
            autovalidateMode: AutovalidateMode.disabled, // Manual validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Space for the header
                const SizedBox(height: 20),

                // 1. Header Text
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter your information',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // 2. Country Selector Dropdown
                SelectCountryField(
                  selectedCountryData: _selectedCountryData,
                  onChanged: (newValue) {
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
                const SizedBox(height: 20),

                // 3. First Name Field
                CustomTextField(
                  controller: _firstNameController,
                  labelText: 'First name or Given name',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name or Given name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 4. Last Name Field
                CustomTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name or Surname',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last Name or Surname is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 150),

                // 5. Continue Button
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    final bool isValid =
                        _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    // Manually validate to show errors if fields are empty
                    if (!_formKey.currentState!.validate()) return;

                    final String? selectedCode = _selectedCountryData?['code'];

                    // Use the custom route for the transition
                    Navigator.of(context).push(
                      _createRightToLeftRoute(
                        SignupScreen2(initialCountryCode: selectedCode),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),

                // 6. Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
