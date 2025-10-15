import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nec_app/screens/rewards/rewards_screen.dart';
import 'package:nec_app/screens/history/history_screen.dart';
import 'package:nec_app/screens/more/more_screen.dart';
import 'package:nec_app/screens/send/recievers_screen.dart';
import 'package:nec_app/screens/homescreen/home_screen.dart';
import 'package:nec_app/theme/theme_data.dart';

enum NavTab { home, rewards, history, more }

Route<T> _noAnimationRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

class NavBar extends StatelessWidget {
  final NavTab? selectedTab; // null means no tab is selected (e.g., Send screen)
  const NavBar({super.key, this.selectedTab});

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = AppColors.primary;
    const Color unselectedColor = AppColors.textSecondary;
    Color colorFor(NavTab tab) => selectedTab == tab ? selectedColor : unselectedColor;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      clipBehavior: Clip.none,
      child: Container(
        height: 60.0,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.home_filled,
                    svgAsset: 'assets/icons/nav_home.svg',
                    iconSize: 22,
                    label: 'Home',
                    color: colorFor(NavTab.home),
                    onTap: () {
                      if (selectedTab == NavTab.home) return;
                      Navigator.of(context).pushReplacement(
                        _noAnimationRoute(const HomeScreen()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.card_giftcard_rounded,
                    svgAsset: 'assets/icons/nav_reward.svg',
                    iconSize: 22,
                    label: 'Rewards',
                    color: colorFor(NavTab.rewards),
                    onTap: () {
                      if (selectedTab == NavTab.rewards) return;
                      Navigator.of(context).pushReplacement(
                        _noAnimationRoute(const RewardsScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 76.0), // space for center FAB
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.history,
                    svgAsset: 'assets/icons/nav_history.svg',
                    iconSize: 22,
                    label: 'History',
                    color: colorFor(NavTab.history),
                    onTap: () {
                      if (selectedTab == NavTab.history) return;
                      Navigator.of(context).pushReplacement(
                        _noAnimationRoute(const HistoryScreen()),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.grid_view_rounded,
                    label: 'More',
                    color: colorFor(NavTab.more),
                    onTap: () {
                      if (selectedTab == NavTab.more) return;
                      Navigator.of(context).pushReplacement(
                        _noAnimationRoute(const MoreScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 4,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    _noAnimationRoute(const ReceiversScreen()),
                  );
                },
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selectedTab == null
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    String? svgAsset,
    double iconSize = 24,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgAsset == null)
              Icon(icon, size: iconSize, color: color)
            else
              SvgPicture.asset(
                svgAsset,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 2), // balanced overlap with BottomAppBar
      child: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              _noAnimationRoute(const ReceiversScreen()),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 10,
          focusElevation: 10,
          hoverElevation: 10,
          highlightElevation: 10,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.transparent, width: 0),
          ),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment.center,
                radius: 0.9,
                // center -> edge
                colors: [
                  AppColors.success, // lighter center
                  AppColors.primaryDark, // deeper edge
                ],
                stops: [0.3, 1.0],
              ),
              border: Border.all(color: Colors.white24, width: 1),
              boxShadow: const [
                // Primary drop shadow (depth)
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 5,
                  offset: Offset(0, 6),
                ),
                // Contact shadow near surface
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
                // Very subtle ambient glow
                BoxShadow(
                  color: Color(0x1A2E7D32),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.28), // top highlight
                  Colors.white.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.55],
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/send_icon.svg',
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
