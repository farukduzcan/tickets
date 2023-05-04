import 'package:flutter/material.dart';
import 'package:tickets/components/drawer_item.dart';
import 'package:tickets/models/user_model.dart';
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
          UserAccountsDrawerHeader(
            accountName: Text(
                "${UserModel.userData!.firstName!} ${UserModel.userData!.lastName!}"),
            accountEmail: Text(UserModel.userData!.email!),
            currentAccountPicture: Row(
              children: const [
                CircleAvatar(
                  radius: 35,
                  child: ClipOval(
                    child: Icon(
                      Icons.business_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Company Name", style: TextStyle(color: Colors.white)),
              ],
            ),
            decoration: const BoxDecoration(),
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
