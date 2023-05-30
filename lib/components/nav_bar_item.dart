import 'package:flutter/material.dart';
import 'package:tickets/constants.dart';

class NavBarItem extends StatelessWidget {
  final double? width;
  final String title;
  final IconData icon;
  final Function press;
  final bool isActive;
  const NavBarItem({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
    this.isActive = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(30), right: Radius.circular(30)),
      ),
      minWidth: width,
      onPressed: () {
        press();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? kPrimaryColor : Colors.black),
          Text(title,
              style: TextStyle(
                color: isActive ? kPrimaryColor : Colors.black,
              )),
        ],
      ),
    );
  }
}
