import 'package:flutter/material.dart';
import 'signup_screen_1.dart';
import 'login_screen.dart';
import 'package:nec_app/widgets/common_card.dart'; // Import the new CommonCard widget

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
        Image.asset('assets/images/logo.png', height: 100, width: 200),
      ],
    );
  }

  Widget _buildCurrencyConverterCard() {
    // Using the new CommonCard widget
    return const CommonCard(
      child: SizedBox(
        height: 250, // Placeholder height
        child: Text('Converter', textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    // Using the new CommonCard widget
    return CommonCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _pushRightToLeft(context, const LoginScreen());
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black, // Text color
                side: const BorderSide(color: Colors.grey), // Border color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'LOG IN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 10), // Space between buttons
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _pushRightToLeft(context, const SignupScreen1());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _lightGreenButton, // Light grey background
                foregroundColor: _primaryGreen, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0, // Remove shadow
              ),
              child: const Text(
                'SIGN UP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                bottom: 200, // leave more space for WhatsApp button area
                left: 0,
                child: _SideBarDecoration(isRight: false),
              ),
              const Positioned(
                top: 0,
                bottom: 200, // leave more space for WhatsApp button area
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
                                child: Image.asset(
                                  'assets/images/Vector.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                // top: 30.0,
                                left: 10.0,
                                right: 10.0,
                                bottom: 20.0,
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
                right: 15,
                bottom: 15,
                child: _WhatsAppButtonPlaceholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for the WhatsApp Button logic and UI
class _WhatsAppButtonPlaceholder extends StatelessWidget {
  const _WhatsAppButtonPlaceholder();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("WhatsApp Support Clicked");
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(),
        child: Image.asset('assets/images/whatsapp_logo.png', height: 40),
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
        'assets/images/Rectangletop.png',
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
        'assets/images/Rectangleside.png',
        fit: BoxFit.cover,
        alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      ),
    );
  }
}