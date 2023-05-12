import 'package:flutter/material.dart';
import 'package:tickets/constants.dart';

class NavBarItem extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
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
