import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Colors.green.shade700;
    const Color unselectedColor = Colors.black54;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: const Color(0xFFEDEDED),
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE6E6E6), width: 1),
          ),
        ),
        height: 64.0,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.home_filled,
                    label: 'Home',
                    color: selectedColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Home tapped')),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.card_giftcard_rounded,
                    label: 'Rewards',
                    color: unselectedColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rewards tapped')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 72.0), // space for center FAB
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.history,
                    label: 'History',
                    color: unselectedColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('History tapped')),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.grid_view_rounded,
                    label: 'More',
                    color: unselectedColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('More tapped')),
                      );
                    },
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Send tapped')),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 36),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
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
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
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
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.transparent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: const CircleBorder(side: BorderSide(color: Colors.transparent, width: 0)),
      child: Image.asset(
        'assets/images/send_icon.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }
}