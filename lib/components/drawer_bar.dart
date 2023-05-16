import 'package:flutter/material.dart';
import 'package:tickets/components/drawer_item.dart';
import 'package:tickets/models/user_model.dart';
import '../constants.dart';

class DrawerBar extends StatefulWidget {
  final List<bool> isActivated;
  final int currentIndex;
  final List<StatefulWidget> screens;
  const DrawerBar({
    super.key,
    required this.isActivated,
    required this.currentIndex,
    required this.screens,
  });

  @override
  State<DrawerBar> createState() => _DrawerBarState();
}

class _DrawerBarState extends State<DrawerBar> {
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
            press: () {
              widget.isActivated[0];
            },
            icon: Icons.home,
          ),
          DrawerItem(
            isSelected: false,
            title: kProfileTitle,
            press: () {
              widget.isActivated[2];
            },
            icon: Icons.person,
          ),
          DrawerItem(
            isSelected: false,
            title: kSettingsTitle,
            press: () {
              widget.isActivated[1];
            },
            icon: Icons.settings,
          ),
          DrawerItem(
            isSelected: false,
            title: kLogoutTitle,
            press: () {
              widget.isActivated[0];
            },
            icon: Icons.logout_outlined,
          ),
        ],
      ),
    );
  }
}
