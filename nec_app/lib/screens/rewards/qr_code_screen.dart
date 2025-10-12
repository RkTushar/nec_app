import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../widgets/buttons/back_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../theme/theme_data.dart';

class MyQrCodeScreen extends StatefulWidget {
  const MyQrCodeScreen({super.key});

  @override
  _MyQrCodeScreenState createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  // This is the data that will be encoded in the QR code.
  // Replace this with the user's specific data, like a user ID or a URL.
  final String qrData = 'https://www.google.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Custom header with just back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  AppBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title above QR code
                    Text(
                      'My QR Code',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // QR Code with green corner brackets
                    SizedBox(
                      width: 360,
                      height: 380,
                      child: Stack(
                        children: [
                          // QR Code Container with larger white background
                          Center(
                            child: Container(
                              width: 340,
                              height: 360,
                              padding: EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 0,
                                    blurRadius: 15,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: QrImageView(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 260.0,
                                  eyeStyle: const QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: AppColors.primary,
                                  ),
                                  dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Green corner brackets positioned around the QR code
                          // Top-left bracket
                          Positioned(
                            top: 30,
                            left: 30,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.primary, width: 5),
                                  left: BorderSide(color: AppColors.primary, width: 5),
                                ),
                              ),
                            ),
                          ),
                          // Top-right bracket
                          Positioned(
                            top: 30,
                            right: 30,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppColors.primary, width: 5),
                                  right: BorderSide(color: AppColors.primary, width: 5),
                                ),
                              ),
                            ),
                          ),
                          // Bottom-left bracket
                          Positioned(
                            bottom: 30,
                            left: 30,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.primary, width: 5),
                                  left: BorderSide(color: AppColors.primary, width: 5),
                                ),
                              ),
                            ),
                          ),
                          // Bottom-right bracket
                          Positioned(
                            bottom: 30,
                            right: 30,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: AppColors.primary, width: 5),
                                  right: BorderSide(color: AppColors.primary, width: 5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Download text
                    Text(
                      'Download your QR code',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Download button using SecondaryButton
                    SecondaryButton(
                      label: 'Download',
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      height: 48,
                      width: 200,
                      borderRadius: BorderRadius.circular(30),
                      leading: Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        // TODO: Implement the download functionality here
                        // This would involve saving the QR code image to the device's gallery
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}