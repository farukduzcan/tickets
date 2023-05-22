import 'package:flutter/material.dart';

class TicketActionBottomButon extends StatelessWidget {
  final Function press;
  final String buttonText;
  final IconData icon;
  final Color? iconColor;
  const TicketActionBottomButon({
    super.key,
    required this.buttonText,
    required this.icon,
    this.iconColor,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(buttonText),
        trailing: Icon(icon, color: iconColor ?? Colors.black),
        onTap: () {
          press();
        },
      ),
    );
  }
}
