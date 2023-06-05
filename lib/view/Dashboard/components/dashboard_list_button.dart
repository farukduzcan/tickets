import 'package:flutter/material.dart';

import '../../../constants.dart';

class DashBoardListButton extends StatelessWidget {
  final Function press;
  final String title;
  final Icon icon;
  const DashBoardListButton({
    super.key,
    required this.press,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kCardBoxShodow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          trailing: const Icon(Icons.arrow_forward_ios),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () {
            press();
          },
          title: Text(title),
          leading: icon,
        ),
      ),
    );
  }
}
