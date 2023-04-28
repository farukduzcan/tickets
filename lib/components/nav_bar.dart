import 'package:flutter/material.dart';
import 'package:tickets/components/nav_bar_item.dart';
import 'package:tickets/constants.dart';

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
                    icon: Icons.home_outlined, title: kHomeTitle, press: () {}),
                NavBarItem(
                    icon: Icons.person_outline,
                    title: kProfileTitle,
                    press: () {}),
              ],
            ),
            Row(
              children: [
                NavBarItem(
                    icon: Icons.settings_outlined,
                    title: kSettingsTitle,
                    press: () {}),
                NavBarItem(
                    icon: Icons.logout_outlined,
                    title: kLogoutTitle,
                    press: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
