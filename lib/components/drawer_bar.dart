import 'package:flutter/material.dart';
import 'package:tickets/components/drawer_item.dart';
import 'package:tickets/models/user_model.dart';
import '../constants.dart';

class DrawerBar extends StatefulWidget {
  final String? companyName;
  const DrawerBar({
    super.key,
    this.companyName,
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
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15,
                          top: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: ClipOval(
                                child: Icon(
                                  UserModel.userData!.role == 2
                                      ? Icons.business_outlined
                                      : Icons.person,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                            Text(
                              "    ${widget.companyName}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                            "${UserModel.userData!.firstName!} ${UserModel.userData!.lastName!}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                      Text(
                        UserModel.userData!.email!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 1,
                        ),
                      ),
                    ],
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
                  title: kCatocoryTitle,
                  press: () {},
                  icon: Icons.category_rounded,
                ),
                DrawerItem(
                  isSelected: false,
                  title: kLogoutTitle,
                  press: () {},
                  icon: Icons.logout_outlined,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              kVersionTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
