import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/buttons/back_button.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button.dart';
import 'package:nec_app/widgets/buttons/secondary_button.dart';
import 'package:nec_app/services/currency_prefs.dart';
import 'package:nec_app/widgets/buttons/notification_button.dart';
import 'package:nec_app/models/notification_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nec_app/screens/rewards/qr_code_screen.dart';
import 'package:nec_app/screens/rewards/invite_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key, this.showNavBar = true});

  final bool showNavBar;

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  String _symbol = '£';
  String? _currencyCode;

  @override
  void initState() {
    super.initState();
    _loadSymbolAndCurrency();
  }

  Future<void> _loadSymbolAndCurrency() async {
    final String? s = await CurrencyPrefs.loadCurrencySymbol();
    if (s != null && s.isNotEmpty && s != _symbol) {
      setState(() => _symbol = s);
    }

    final String? currencyCode = await CurrencyPrefs.loadSenderCurrencyCode();
    if (currencyCode != null && currencyCode.isNotEmpty) {
      setState(() => _currencyCode = currencyCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.showNavBar ? null : const AppBackButton(),
        title: const Text('Reward', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
        actions: widget.showNavBar
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: NotificationButton(backgroundColor: AppColors.primary, count: NotificationModel.getTotalCount()),
                ),
              ]
            : null,
        centerTitle: false,
        titleSpacing: 16,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _InviteFriendsCard(textTheme: textTheme, currencySymbol: _symbol, currencyCode: _currencyCode),
          const SizedBox(height: 12),
          _TotalRewardCard(textTheme: textTheme, currencySymbol: _symbol),
          const SizedBox(height: 12),
          _QrCodeCard(textTheme: textTheme),
          const SizedBox(height: 12),
          _FaqSection(textTheme: textTheme),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'To know more',
            onPressed: () async {
              final Uri uri = Uri.parse('https://www.necmoney.com/promotion-offer/get-a-5-bonus-on-your-first-transfer');
              final bool launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              if (!launched && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open link. Please try again.')),
                );
              }
            },
            outlined: true,
            height: 56,
            backgroundColor: Colors.white,
            borderColor: AppColors.border,
            foregroundColor: AppColors.primaryDark,
            leading: Icon(Icons.link_rounded, size: 20, color: AppColors.primaryDark),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 72),
        ],
      ),
      floatingActionButton: widget.showNavBar ? const CustomFloatingActionButton() : null,
      floatingActionButtonLocation: widget.showNavBar ? FloatingActionButtonLocation.centerDocked : null,
      bottomNavigationBar: widget.showNavBar ? NavBar(selectedTab: NavTab.rewards) : null,
    );
  }
}


class _InviteFriendsCard extends StatelessWidget {
  const _InviteFriendsCard({required this.textTheme, required this.currencySymbol, this.currencyCode});

  final TextTheme textTheme;
  final String currencySymbol;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    return _OutlinedCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite More & Get More',
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 17,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get ${currencySymbol}5 each invite',
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                InviteButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InviteScreen(currencyCode: currencyCode)));
                  },
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/images/reward_dollar.svg',
            width: 180,
            height: 180,
          ),
        ],
      ),
    );
  }
}

class _TotalRewardCard extends StatelessWidget {
  const _TotalRewardCard({required this.textTheme, required this.currencySymbol});

  final TextTheme textTheme;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return _OutlinedCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL REWARD',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${currencySymbol}5.00',
                  style: textTheme.headlineSmall?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/images/reward_2.svg',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}

class _QrCodeCard extends StatelessWidget {
  const _QrCodeCard({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      label: 'My QR code',
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyQrCodeScreen()));
      },
      outlined: true,
      height: 50,
      backgroundColor: Colors.white,
      borderColor: AppColors.border,
      foregroundColor: AppColors.primaryDark, // dark green from theme
      leading: SvgPicture.asset(
        'assets/icons/more_screen/qr_icon.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(AppColors.primaryDark, BlendMode.srcIn),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    );
  }
}

class _FaqSection extends StatefulWidget {
  const _FaqSection({required this.textTheme});

  final TextTheme textTheme;

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  int _openIndex = -1; // -1 means all closed

  @override
  Widget build(BuildContext context) {
    // Match UI: no enclosing card or title. Use screen background and spaced tiles only.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FaqTile(
          title: 'How do referrals work?',
          expanded: _openIndex == 0,
          onTap: () => setState(() => _openIndex = _openIndex == 0 ? -1 : 0),
          body:
              '''Share Nec Money with friends, family, coworkers, or anyone who needs to send money.
Earn rewards when the people you refer send the minimum amount (£25) on their first transfer.
Your rewards will automatically apply the next time when you will send money .
Additional send requirements may be required for rewards to apply.
You can earn rewards for up to 1000 successful referrals.''',
        ),
        _FaqTile(
          title: 'How do I use my rewards?',
          expanded: _openIndex == 1,
          onTap: () => setState(() => _openIndex = _openIndex == 1 ? -1 : 1),
          body: 'You can use your reward on your next transfer. '
              'Additional send requirements may be required for rewards to apply.',
        ),
        _FaqTile(
          title: "Why haven't I received my rewards?",
          expanded: _openIndex == 2,
          onTap: () => setState(() => _openIndex = _openIndex == 2 ? -1 : 2),
          body: '''If you referred someone but didn't earn rewards, it could be because:
• They haven't sent a transfer yet.
• Their transfer was canceled.
• They sent less than the minimum required.
• You already got rewarded for successfully referring 1000 friends.
• Other send requirements were not met for the reward to apply.

You'll earn rewards when their first transfer is completed.

If you didn't receive the new customer offer you expected:
• We missed some details when you signed up.
• You changed your sending country. Our offers are different depending on your location.

If you think you're missing rewards, contact us for help.''',
        ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.title, required this.expanded, required this.onTap, this.body});

  final String title;
  final bool expanded;
  final VoidCallback onTap;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg, // match screen background
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 6), // show white gap from card between tiles
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            if (expanded && body != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  body!,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OutlinedCard extends StatelessWidget {
  const _OutlinedCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      padding: padding ?? const EdgeInsets.all(12),
      child: child,
    );
  }
}


