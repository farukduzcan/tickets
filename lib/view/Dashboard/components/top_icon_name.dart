import 'package:flutter/material.dart';

class TopIconAndText extends StatelessWidget {
  final IconData icon;
  final String welcomeText;
  final String nameText;
  const TopIconAndText({
    Key? key,
    required this.icon,
    required this.welcomeText,
    required this.nameText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(
            '$welcomeText\n$nameText',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
          )
        ],
      ),
    );
  }
}
