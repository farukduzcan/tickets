import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/already_account.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/view/Login/login_screen.dart';
import 'package:tickets/view/Signup/components/register_form.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginAndRegisterBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(kRegisterTitle, style: kTitleStyle),
            ),
            Lottie.asset('assets/lottie/register_page.json',
                width: size.width * 0.50, repeat: false),
            //Email
            RegisterForm(formKey: _formKey),
            RaundedButton(
                buttonText: kRegisterButtonTitle,
                press: () {
                  if (_formKey.currentState?.validate() ?? false) {}
                }),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AlreadyHaveAnAccount(
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }),
                    );
                  },
                  login: false),
            ),
          ],
        ),
      ),
    );
  }
}
