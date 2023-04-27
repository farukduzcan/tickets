
import 'package:flutter/material.dart';
import 'package:tickets/components/nav_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                NavBarItem(
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    press: () {}),
                NavBarItem(
                    icon: Icons.person_outline,
                    title: 'Profile',
                    press: () {}),
              ],
            ),
            Row(
              children: [
                NavBarItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    press: () {}),
                NavBarItem(
                    icon: Icons.logout_outlined,
                    title: 'Logout',
                    press: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
