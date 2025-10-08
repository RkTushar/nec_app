import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'signup_screen_1.dart';
import 'login_screen.dart';
import 'package:nec_app/widgets/cards/common_card.dart'; // Import the new CommonCard widget
import 'package:nec_app/widgets/buttons/secondary_button.dart';
import 'package:nec_app/widgets/converters/converter_widget.dart';
import 'package:nec_app/widgets/buttons/whatsapp.dart';

// --- COLOR CONSTANTS (Based on UI Analysis) ---
const Color _primaryGreen = Color(0xFF1B6A00); // Dark green header
// const Color _accentRed = Color(0xFFB71C1C);    // Exchange rate color
const Color _lightGreyBackground = Color(
  0xFFE0E0E0,
); // Lighter shade for base screen
const Color _lightGreenButton = Color(
  0xFFE0E0E0,
); // Lighter shade for signup button

class AuthChoose extends StatelessWidget {
  const AuthChoose({super.key});

  // Slide transition: right -> left
  void _pushRightToLeft(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) => page,
        transitionsBuilder: (
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
          final Animation<Offset> offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // --- PLACEHOLDER WIDGETS ---
  Widget _buildHeader() {
    return Column(
      children: [
        // The logo is now the only widget in the header column.
        SvgPicture.asset('assets/images/logo.svg', height: 100, width: 200),
      ],
    );
  }

  Widget _buildCurrencyConverterCard() {
    // Using the new CommonCard widget
    return const CommonCard(
      child: ConverterWidget(),
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    // Using the new CommonCard widget
    return CommonCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SecondaryButton(
              label: 'LOG IN',
              onPressed: () {
                _pushRightToLeft(context, const LoginScreen());
              },
              outlined: true,
              foregroundColor: Colors.black,
              borderColor: Colors.grey,
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 15),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(width: 10), // Space between buttons
          Expanded(
            child: SecondaryButton(
              label: 'SIGN UP',
              onPressed: () {
                _pushRightToLeft(context, const SignupScreen1());
              },
              outlined: false,
              backgroundColor: _lightGreenButton,
              foregroundColor: _primaryGreen,
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 15),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }

  // --- MAIN BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _lightGreyBackground,
      body: SafeArea(
        child: ClipRRect(
          // Applies the border radius to the corners
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6.0),
            bottomRight: Radius.circular(6.0),
          ),
          child: Stack(
            children: [
              // Decorative fixed bars aligned with header and vector sections
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopBarDecoration(),
              ),
              const Positioned(
                top: 0,
                bottom: 500, // leave more space for WhatsApp button area
                left: 0,
                child: _SideBarDecoration(isRight: false),
              ),
              const Positioned(
                top: 0,
                bottom: 500, // leave more space for WhatsApp button area
                right: 0,
                child: _SideBarDecoration(isRight: true),
              ),

              // The logo is placed at the top using a Positioned widget
              Positioned(top: 50, left: 0, right: 0, child: _buildHeader()),

              // The Vector.png container is placed below the header
              Positioned(
                top: 200, // Restore previous vector position
                left: 0,
                right: 0,
                bottom: 0, // Allows the container to fill the remaining space
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Transform.scale(
                                scale: 1.1, // slight zoom on background vector
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                  child: Image.asset(
                                    'assets/decoration/Vector.png',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom: 40.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // const SizedBox(height: 8.0),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: const Text(
                                      'Fast & Secure',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildCurrencyConverterCard(),
                                  const SizedBox(height: 20),
                                  _buildAuthCard(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // WhatsApp FAB is placed on top of everything
              const Positioned(
                right: 20,
                bottom: 20,
                child: WhatsAppButton(size: 54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fixed top decorative bar using Rectangletop asset
class _TopBarDecoration extends StatelessWidget {
  const _TopBarDecoration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      child: Image.asset(
        'assets/decoration/Rectangle_sidebar.png',
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

// Fixed side decorative bars using Rectangleside asset
class _SideBarDecoration extends StatelessWidget {
  final bool isRight;
  const _SideBarDecoration({required this.isRight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15,
      child: Image.asset(
        'assets/decoration/Rectangle_sidebar.png',
        fit: BoxFit.cover,
        alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      ),
    );
  }
}