import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button.dart';
import 'package:nec_app/widgets/buttons/secondary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  String _symbol = '£';

  @override
  void initState() {
    super.initState();
    _loadSymbol();
  }

  Future<void> _loadSymbol() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? s = prefs.getString('currencySymbol');
    if (s != null && s.isNotEmpty && s != _symbol) {
      setState(() => _symbol = s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Reward'),
        centerTitle: false,
        titleSpacing: 16,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _InviteFriendsCard(textTheme: textTheme, currencySymbol: _symbol),
          const SizedBox(height: 12),
          _TotalRewardCard(textTheme: textTheme, currencySymbol: _symbol),
          const SizedBox(height: 12),
          _QrCodeCard(textTheme: textTheme),
          const SizedBox(height: 12),
          _FaqSection(textTheme: textTheme),
          const SizedBox(height: 72),
        ],
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavBar(selectedTab: NavTab.rewards),
    );
  }
}


class _InviteFriendsCard extends StatelessWidget {
  const _InviteFriendsCard({required this.textTheme, required this.currencySymbol});

  final TextTheme textTheme;
  final String currencySymbol;

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
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get ${currencySymbol}5 each invite',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const InviteButton(),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/images/reward_1.svg',
            width: 92,
            height: 92,
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${currencySymbol}5.00',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            'assets/images/reward_2.svg',
            width: 84,
            height: 84,
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
    return _OutlinedCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SecondaryButton(
        label: 'My QR code',
        onPressed: () {},
        outlined: true,
        height: 40,
        backgroundColor: Colors.white,
        borderColor: AppColors.border,
        foregroundColor: AppColors.accentBlue,
        leading: const Icon(Icons.qr_code_2, color: AppColors.accentBlue, size: 18),
      ),
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
    return _OutlinedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rewards',
            style: widget.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          _FaqTile(
            title: 'How do referrals work?',
            expanded: _openIndex == 0,
            onTap: () => setState(() => _openIndex = _openIndex == 0 ? -1 : 0),
            body: 'Share Nec Money with friends, family, coworkers, or anyone who needs to send money. '
                'Earn rewards when the people you refer send the minimum amount (£25) on their first transfer. '
                'Your rewards will automatically apply the next time when you will send money. '
                'Additional send requirements may be required for rewards to apply. '
                'You can earn rewards for up to 1000 successful referrals.',
          ),
          //  const Divider(height: 1),
          _FaqTile(
            title: 'How do I use my rewards?',
            expanded: _openIndex == 1,
            onTap: () => setState(() => _openIndex = _openIndex == 1 ? -1 : 1),
            body: 'You can use your reward on your next transfer. '
                'Additional send requirements may be required for rewards to apply.',
          ),
          // const Divider(height: 1),
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
      ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
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
              Text(
                body!,
                style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, height: 1.35),
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


