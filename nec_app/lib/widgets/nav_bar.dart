import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Colors.green.shade700;
    const Color unselectedColor = Colors.black54;
    void _log(String message) => debugPrint(message);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 0,
      color: const Color(0xFFEDEDED),
      elevation: 0,
      clipBehavior: Clip.none,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE6E6E6), width: 1),
          ),
        ),
        height: 56.0,
        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    onTap: () { _log('Home tapped'); },
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.card_giftcard_rounded,
                    label: 'Rewards',
                    color: unselectedColor,
                    onTap: () { _log('Rewards tapped'); },
                  ),
                ),
                const SizedBox(width: 72.0), // space for center FAB
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.history,
                    label: 'History',
                    color: unselectedColor,
                    onTap: () { _log('History tapped'); },
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.grid_view_rounded,
                    label: 'More',
                    color: unselectedColor,
                    onTap: () { _log('More tapped'); },
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () { _log('Send tapped'); },
              child: const Padding(
                padding: EdgeInsets.only(top: 32),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
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
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 22), // keep half inside the bar
      child: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () { debugPrint('Send tapped'); },
          backgroundColor: Colors.transparent,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.transparent, width: 0),
          ),
          child: Image.asset(
            'assets/images/send_icon.png',
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}