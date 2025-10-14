import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/models/notification_model.dart';
import 'package:nec_app/theme/theme_data.dart';
import 'package:nec_app/widgets/buttons/invite/invite_button_2.dart';
import 'package:nec_app/widgets/buttons/notification_button.dart';
import 'package:nec_app/widgets/nav_bar.dart';
import 'package:nec_app/screens/more/track_transaction.dart';
import 'package:nec_app/screens/rewards/qr_code_screen.dart';
import 'package:nec_app/screens/rewards/invite_screen.dart';
import 'package:nec_app/widgets/share_link_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ProfileHeader(primaryColor: primary, notificationCount: NotificationModel.getTotalCount()),
              const SizedBox(height: 30),
              const _SectionTitle('Account'),
              const SizedBox(height: 10),
              const _AccountGrid(),
              const SizedBox(height: 30),
              const _SectionTitle('Support And Others'),
              const SizedBox(height: 8),
              _SupportGrid(),
            ],
          ),
        ),
      ),
      floatingActionButton: const CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const NavBar(selectedTab: NavTab.more),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Color primaryColor;
  final int notificationCount;
  const _ProfileHeader({required this.primaryColor, this.notificationCount = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(
              'assets/icons/profile_icon.svg',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hello!', style: TextStyle(fontSize: 13)),
                SizedBox(height: 2),
                Text('Kamal Ahmed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('NGB76121', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InviteButton2(backgroundColor: primaryColor, foregroundColor: Colors.white),
              const SizedBox(width: 8),
              NotificationButton(count: notificationCount, backgroundColor: primaryColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 19));
  }
}

class _AccountGrid extends StatelessWidget {
  final List<_MenuItem> items = const <_MenuItem>[
    _MenuItem('Personal Info', 'assets/icons/more_screen/profile.svg'),
    _MenuItem('Upload Document', 'assets/icons/more_screen/upload_doc.svg'),
    _MenuItem('View Document', 'assets/icons/more_screen/view_doc.svg'),
    _MenuItem('Tracking Transaction', 'assets/icons/more_screen/tracking.svg'),
    _MenuItem('Apply Cancellation', 'assets/icons/more_screen/apply_cancel.svg'),
    _MenuItem('Apply Correction', 'assets/icons/more_screen/apply_correction.svg'),
    _MenuItem('Receivers', 'assets/icons/more_screen/recievers.svg'),
    _MenuItem('My Rewards', 'assets/icons/more_screen/my_rewards.svg'),
    _MenuItem('Invite Friends', 'assets/icons/more_screen/invite_friends.svg'),
    _MenuItem('My QR code', 'assets/icons/more_screen/qr_icon.svg'),
  ];

  const _AccountGrid();

  @override
  Widget build(BuildContext context) {
    return _GridMenu(items: items);
  }
}

class _SupportGrid extends StatelessWidget {
  final List<_MenuItem> items = const <_MenuItem>[
    _MenuItem('Contact Us', 'assets/icons/more_screen/contact_us.svg'),
    _MenuItem('Feedback', 'assets/icons/more_screen/feedback.svg'),
    _MenuItem('About us', 'assets/icons/more_screen/about_us.svg'),
    _MenuItem('Rating', 'assets/icons/more_screen/rating.svg'),
    _MenuItem('Privacy Policy', 'assets/icons/more_screen/privacy_policy.svg'),
    _MenuItem('Terms & Conditions', 'assets/icons/more_screen/terms_condition.svg'),
    _MenuItem('Change Password', 'assets/icons/more_screen/change_pass.svg'),
    _MenuItem('Update now', 'assets/icons/more_screen/update_now.svg'),
    _MenuItem('Share App Link', 'assets/icons/more_screen/share_app.svg'),
    _MenuItem('Log Out', 'assets/icons/more_screen/log_out.svg', danger: true),
  ];

  _SupportGrid();

  @override
  Widget build(BuildContext context) {
    return _GridMenu(items: items);
  }
}

class _GridMenu extends StatelessWidget {
  final List<_MenuItem> items;
  const _GridMenu({required this.items});

  @override
  Widget build(BuildContext context) {
    final Color border = Theme.of(context).dividerColor.withOpacity(0.15);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final _MenuItem item = items[index];
          final bool isDanger = item.danger == true;
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {
                if (item.label == 'Tracking Transaction') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TrackTransactionScreen()),
                  );
                } else if (item.label == 'My QR code') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyQrCodeScreen()),
                  );
                } else if (item.label == 'Invite Friends') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InviteScreen()),
                  );
                } else if (item.label == 'Share App Link') {
                  const String referralText = 'https://necmoneyreferral.onelink.me/';
                  ShareLinkWidget.shareText(
                    referralText,
                    subject: 'Join me on NEC Money!',
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              splashColor: AppColors.primary.withOpacity(0.12),
              highlightColor: AppColors.primary.withOpacity(0.06),
              child: Container(
                decoration: BoxDecoration(
                  // keep subtle border and shadow outside ripple
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
                  ],
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _MenuIcon(item: item, isDanger: isDanger),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 32, // reserve equal space for 1-2 lines to align rows
                      child: Center(
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDanger ? AppColors.error : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        ),
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final _MenuItem item;
  final bool isDanger;
  const _MenuIcon({required this.item, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    // Color retained for potential future use when mixing SVG and Material icons.
    final bool isSvg = item.asset != null;
    final double size = isSvg ? 32 : 28; // larger sizes to better fill cards
    return SizedBox(
      height: 42,
      child: Center(
        child: SvgPicture.asset(
          item.asset!,
          width: size,
          height: size,
          // Make only QR icon green; others keep original colors
          colorFilter: item.asset!.endsWith('qr_icon.svg')
              ? ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final String? asset; // svg path for the icon
  final bool? danger;
  const _MenuItem(this.label, this.asset, {this.danger});
}


