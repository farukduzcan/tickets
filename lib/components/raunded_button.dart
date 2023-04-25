import 'package:flutter/material.dart';

import '../constants.dart';

class RaundedButton extends StatelessWidget {
  final String buttonText;
  final Function press;
  final Color color, textColor, shadowColor;
  final double elevation;
  const RaundedButton({
    super.key,
    required this.buttonText,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.shadowColor = kPrimaryLightColor,
    this.elevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            spreadRadius: 3, // gölge genişliği değiştirir
            blurRadius: 7, // gölge yumuşaklığı değiştirir
            offset: const Offset(0,
                3), // gölge pozisyonu değiştirir (x,y koordinatları için) (0,3) (x,y)
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      width: size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: elevation,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          press();
        },
        child: Text(
          buttonText,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
