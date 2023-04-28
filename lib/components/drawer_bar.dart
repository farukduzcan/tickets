import 'package:flutter/material.dart';
import 'package:tickets/components/drawer_item.dart';
import '../constants.dart';

class DrawerBar extends StatelessWidget {
  const DrawerBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      width: 233,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Text(
              "VeriPlus",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          DrawerItem(
            isSelected: true,
            title: kHomeTitle,
            press: () {},
            icon: Icons.home,
          ),
          DrawerItem(
            isSelected: false,
            title: kProfileTitle,
            press: () {},
            icon: Icons.person,
          ),
          DrawerItem(
            isSelected: false,
            title: kSettingsTitle,
            press: () {},
            icon: Icons.settings,
          ),
          DrawerItem(
            isSelected: false,
            title: kLogoutTitle,
            press: () {},
            icon: Icons.logout_outlined,
          ),
        ],
      ),
    );
  }
}
