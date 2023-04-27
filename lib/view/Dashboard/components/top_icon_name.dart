import 'package:flutter/material.dart';

class TopIconAndText extends StatelessWidget {
  IconData icon;
  String welcomeText;
  String nameText;
  TopIconAndText({
    Key? key,
    required this.icon,
    required this.welcomeText,
    required this.nameText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          child: Icon(
            Icons.business_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            Text(
              '$welcomeText\n$nameText',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
