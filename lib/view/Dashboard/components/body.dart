import 'package:flutter/material.dart';
import 'package:tickets/constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: size.height * 0.25,
              decoration: BoxDecoration(
                boxShadow: kContainerBoxShodow,
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            const Positioned(
              top: 50,
              left: 20,
              child: Text(
                'Merhaba Faruk',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}
