import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function press;
  const NavBarItem({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
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
          Icon(icon),
          Text(title),
        ],
      ),
    );
  }
}
