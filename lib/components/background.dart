import 'package:flutter/material.dart';

class LoginAndRegisterBackground extends StatelessWidget {
  const LoginAndRegisterBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 20,
            left: 0,
            child: Image.asset(
              "assets/images/main_left.png",
              width: size.width * 0.1,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.1,
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            right: 0,
            child: Image.asset(
              "assets/images/right_center_1.png",
              width: size.width * 0.08,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
