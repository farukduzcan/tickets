import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/already_account.dart';
import 'package:tickets/components/input_field.dart';
import 'package:tickets/components/password_input_field.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/view/Signup/signup_screen.dart';
import '../../../components/background.dart';

class Body extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginAndRegisterBackground(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(kLoginTitle, style: kTitleStyle),
          Lottie.asset('assets/lottie/login_page.json',
              width: size.width * 0.50, repeat: false),
          Form(
            key: _formKey,
            child: Column(
              children: [
                InputField(
                  autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    hintText: kEmailHintText,
                    icon: Icons.person,
                    onChanged: (value) {}),
                RaundedPasswordField(
                    hintText: kPasswordHintText, onChanged: (value) {}),
              ],
            ),
          ),
          RaundedButton(
              buttonText: kLoginButtonTitle,
              press: () {
                if (_formKey.currentState?.validate() ?? false) {}
              }),
          AlreadyHaveAnAccount(
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const SignUpScreen();
                  }),
                );
              },
              login: true),
        ],
      ),
    ));
  }
}
