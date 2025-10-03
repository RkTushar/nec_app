// Path: login_screen.dart

import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/password_text_field.dart';
import '../../widgets/custom_text_button.dart';
import 'signup_screen_1.dart';
import 'forgot_pass_screen.dart';
import '../../widgets/select_country_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // The state for the selected country is now managed by the widget itself.
  // We'll use a local variable to store the value if needed for submission.
  Map<String, String>? _selectedCountryData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // This is optional, but if you want a default selected country
    // you would need to get it from the widget's internal list.
    // For now, let's keep it simple and just let the widget handle the default.
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- UI Builder Methods ---
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Hi There!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Welcome back, Sign in to your account',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),

        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildBiometricsSection() {
    const Color primaryGreen = Color(0xFF4CAF50);

    return Center(
      child: Column(
        children: [
          const Text(
            'Log in with biometrics',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              // TODO: Add biometric authentication logic here
              debugPrint('Biometrics button tapped!');
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.face_unlock_outlined,
                    size: 48,
                    color: primaryGreen,
                  ),
                  SizedBox(width: 32),
                  Icon(Icons.fingerprint, size: 48, color: primaryGreen),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        CustomTextButton(
          label: 'Create account',
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder:
                    (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) => const SignupScreen1(),
                transitionsBuilder:
                    (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      const Offset startOffset = Offset(1.0, 0.0);
                      const Offset endOffset = Offset.zero;
                      final Animatable<Offset> tween = Tween<Offset>(
                        begin: startOffset,
                        end: endOffset,
                      ).chain(CurveTween(curve: Curves.easeOutCubic));
                      final Animation<Offset> offsetAnimation = animation.drive(
                        tween,
                      );
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                transitionDuration: const Duration(milliseconds: 300),
                reverseTransitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          type: TextButtonType.primary,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 120),
                _buildHeader(),
                const SizedBox(height: 40),

                // Using the refactored SelectCountryField widget
                // We now only need to pass the selected value and the onChanged callback.
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
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final RegExp emailRegex = RegExp(r'^\S+@\S+\.\S+$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                PasswordTextField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextButton(
                    label: 'Forgot your password ?',
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                              ) => ForgotPasswordScreen(
                                initialEmail: emailController.text.trim(),
                              ),
                          transitionsBuilder:
                              (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                              ) {
                                const Offset startOffset = Offset(
                                  -1.0,
                                  0.0,
                                ); // left -> right
                                const Offset endOffset = Offset.zero;
                                final Animatable<Offset> tween = Tween<Offset>(
                                  begin: startOffset,
                                  end: endOffset,
                                ).chain(CurveTween(curve: Curves.easeOutCubic));
                                final Animation<Offset> offsetAnimation =
                                    animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 300),
                          reverseTransitionDuration: const Duration(
                            milliseconds: 300,
                          ),
                        ),
                      );
                    },
                    type: TextButtonType.link,
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Log in',
                  onPressed: () {
                    final bool isValid =
                        _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;
                    // TODO: Add login logic here when valid
                  },
                ),
                const SizedBox(height: 40),
                _buildBiometricsSection(),
                const SizedBox(height: 60),
                _buildSignUpLink(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
