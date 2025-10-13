import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button_2.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'qr_code_screen.dart';

class InviteScreen extends StatelessWidget {
  final String? currencyCode; // ISO 4217 code e.g. GBP, USD
  
  const InviteScreen({super.key, this.currencyCode});

  // Function to share the referral link
  Future<void> _shareReferralLink(String referralText) async {
    try {
      await Share.share(
        referralText,
        subject: 'Join me on NEC Money!',
      );
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  // Moved referral text inside build (to avoid const field error in StatelessWidget)
  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).colorScheme.primary;
    final String referralText =
        "https://necmoneyreferral.onelink.me/";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: AppBackButton(
          iconColor: Theme.of(context).colorScheme.onSurface,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Invite a Friend',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
        child: Column(
          children: [
            // First Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Arc background covering whole card
                  Positioned.fill(
                    top: 100,
                    child: SvgPicture.asset(
                      'assets/decoration/arc_bg_2.svg',
                      fit: BoxFit.fill,
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Logo
                        SvgPicture.asset(
                          'assets/images/logo_2.svg',
                          height: 110,
                        ),
                        const SizedBox(height: 70),

                        // Invite buttons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InviteButton(
                              onPressed: () => _shareReferralLink(referralText),
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '& Get',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InviteButton2(
                              onPressed: () {},
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              currencyCode: currencyCode,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Share your code section
                        Text(
                          'Share your code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Code field
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'NGB76121',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              // Copy button
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      const ClipboardData(text: 'NGB76121'));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Code copied to clipboard'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Share button
                              GestureDetector(
                                onTap: () => _shareReferralLink(referralText),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.share,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Four action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              _ActionButton(
                                icon: Icons.chat,
                                backgroundColor: Colors.white,
                                iconColor: Colors.black,
                                svgAsset: 'assets/images/whatsapp_logo_2.svg',
                                onTap: () async {
                                  print('WhatsApp button tapped');
                                  final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(referralText)}';
                                  print('WhatsApp URL: $whatsappUrl');
                                  try {
                                    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                                      print('Launching WhatsApp URL');
                                      await launchUrl(Uri.parse(whatsappUrl));
                                    } else {
                                      print('WhatsApp not available, copying to clipboard');
                                      await Clipboard.setData(ClipboardData(text: referralText));
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Referral text copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    print('Error launching WhatsApp: $e');
                                    try {
                                      await Clipboard.setData(ClipboardData(text: referralText));
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Referral text copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    } catch (clipboardError) {
                                      print('Error copying to clipboard: $clipboardError');
                                    }
                                  }
                                },
                              ),
                              _ActionButton(
                                icon: Icons.message,
                                backgroundColor: Colors.white,
                                iconColor: Colors.black,
                                svgAsset: 'assets/images/messenger_logo.svg',
                                onTap: () async {
                                  print('Messenger button tapped');
                                  final messengerUrl = 'https://m.me/?text=${Uri.encodeComponent(referralText)}';
                                  print('Messenger URL: $messengerUrl');
                                  try {
                                    if (await canLaunchUrl(Uri.parse(messengerUrl))) {
                                      print('Launching Messenger URL');
                                      await launchUrl(Uri.parse(messengerUrl));
                                    } else {
                                      print('Messenger not available, copying to clipboard');
                                      await Clipboard.setData(ClipboardData(text: referralText));
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Referral text copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    print('Error launching Messenger: $e');
                                    try {
                                      await Clipboard.setData(ClipboardData(text: referralText));
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Referral text copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    } catch (clipboardError) {
                                      print('Error copying to clipboard: $clipboardError');
                                    }
                                  }
                                },
                              ),
                              _ActionButton(
                                icon: Icons.qr_code_2_sharp,
                                backgroundColor: Colors.white,
                                iconColor: Colors.black,
                                svgAsset: 'assets/icons/qr_icon.svg',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MyQrCodeScreen(),
                                    ),
                                  );
                                },
                              ),
                              _ActionButton(
                                icon: Icons.add,
                                backgroundColor: Colors.white,
                                iconColor: Colors.black,
                                onTap: () => _shareReferralLink(referralText),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Second Card - Total Earned
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 24,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total earned',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '0.00 ${currencyCode ?? 'GBP'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String? svgAsset;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.svgAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: backgroundColor == Colors.white
              ? Border.all(color: Colors.grey.shade300)
              : null,
        ),
        child: Center(
          child: svgAsset != null
              ? SvgPicture.asset(
                  svgAsset!,
                  width: 24,
                  height: 24,
                )
              : Icon(
                  icon,
                  size: 24,
                  color: iconColor,
                ),
        ),
      ),
    );
  }
}
