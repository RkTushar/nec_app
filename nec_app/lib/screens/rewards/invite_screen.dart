import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nec_app/services/currency_prefs.dart';

import 'package:nec_app/widgets/share_link_widget.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button_2.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'qr_code_screen.dart';

class InviteScreen extends StatefulWidget {
  final String? currencyCode; // ISO 4217 code e.g. GBP, USD
  
  const InviteScreen({super.key, this.currencyCode});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  String? _effectiveCurrencyCode;

  @override
  void initState() {
    super.initState();
    _loadCurrencyCode();
  }

  Future<void> _loadCurrencyCode() async {
    if ((widget.currencyCode ?? '').trim().isNotEmpty) {
      setState(() => _effectiveCurrencyCode = widget.currencyCode!.trim());
      return;
    }
    final String? savedCode = await CurrencyPrefs.loadSenderCurrencyCode();
    if (!mounted) return;
    setState(() => _effectiveCurrencyCode = (savedCode ?? '').isNotEmpty ? savedCode : null);
  }

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
                              onPressed: () => ShareLinkWidget.shareText(
                                referralText,
                                subject: 'Join me on NEC Money!',
                              ),
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
                              currencyCode: _effectiveCurrencyCode,
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
                              ShareIconButton(
                                text: referralText,
                                subject: 'Join me on NEC Money!',
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
                                  // URL-encode the message
                                  final String message = Uri.encodeComponent(referralText);

                                  // WhatsApp app URI (opens native app)
                                  final Uri whatsappAppUri = Uri.parse('whatsapp://send?text=$message');

                                  // WhatsApp web URI (fallback if app not installed)
                                  final Uri whatsappWebUri = Uri.parse('https://wa.me/?text=$message');

                                  // Platform-specific store URIs
                                  final Uri storeUri = Uri.parse(
                                    Platform.isAndroid
                                        ? 'https://play.google.com/store/apps/details?id=com.whatsapp'
                                        : 'https://apps.apple.com/app/whatsapp-messenger/id310633997',
                                  );

                                  try {
                                    // 1️⃣ Try opening WhatsApp app
                                    if (await canLaunchUrl(whatsappAppUri)) {
                                      await launchUrl(whatsappAppUri, mode: LaunchMode.externalApplication);
                                    }
                                    // 2️⃣ Fallback to WhatsApp web
                                    else if (await canLaunchUrl(whatsappWebUri)) {
                                      await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
                                    }
                                    // 3️⃣ Fallback to Play Store / App Store
                                    else {
                                      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
                                    }
                                  } catch (e) {
                                    // Graceful error handling
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not open WhatsApp: $e')),
                                    );
                                  }
                                },
                              ),
                              _ActionButton(
                                icon: Icons.message,
                                backgroundColor: Colors.white,
                                iconColor: Colors.black,
                                svgAsset: 'assets/images/messenger_logo.svg',
                                onTap: () async {
                                  // URL-encode the message
                                  final String message = Uri.encodeComponent(referralText);

                                  // Messenger native app URI
                                  final Uri messengerAppUri = Uri.parse('fb-messenger://share?link=$message');

                                  // Messenger web fallback
                                  final Uri messengerWebUri = Uri.parse('https://m.me/?text=$message');

                                  // Platform-specific store URIs
                                  final Uri storeUri = Uri.parse(
                                    Platform.isAndroid
                                        ? 'https://play.google.com/store/apps/details?id=com.facebook.orca'
                                        : 'https://apps.apple.com/app/facebook-messenger/id454638411',
                                  );

                                  try {
                                    // 1️⃣ Try opening Messenger app
                                    if (await canLaunchUrl(messengerAppUri)) {
                                      await launchUrl(messengerAppUri, mode: LaunchMode.externalApplication);
                                    }
                                    // 2️⃣ Fallback to Messenger web
                                    else if (await canLaunchUrl(messengerWebUri)) {
                                      await launchUrl(messengerWebUri, mode: LaunchMode.externalApplication);
                                    }
                                    // 3️⃣ Fallback to Play Store / App Store
                                    else {
                                      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not open Messenger: $e')),
                                    );
                                  }
                                },
                              ),
                              _ActionButton(
                                icon: Icons.qr_code_2_sharp,
                                backgroundColor: Colors.white,
                                iconColor: Colors.black,
                                svgAsset: 'assets/icons/more_screen/qr_icon.svg',
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
                                onTap: () => ShareLinkWidget.shareText(
                                  referralText,
                                  subject: 'Join me on NEC Money!',
                                ),
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
                    '0.00 ${_effectiveCurrencyCode ?? ''}',
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
