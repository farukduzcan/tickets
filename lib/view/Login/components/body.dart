import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/already_account.dart';
import 'package:tickets/components/input_field.dart';
import 'package:tickets/components/password_input_field.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/view/Signup/signup_screen.dart';
import '../../../components/background.dart';

import '../../Dashboard/dashboard_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
                    controller: _emailController,
                    focusnode: _emailFocusNode,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    hintText: kEmailHintText,
                    icon: Icons.person,
                    onChanged: (value) {}),
                RaundedPasswordField(
                  controller: _passwordController,
                  focusnode: _passwordFocusNode,
                  hintText: kPasswordHintText,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          RaundedButton(
              buttonText: kLoginButtonTitle,
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const DashboardScreen();
                  }),
                );
                // if (_formKey.currentState?.validate() ?? false) {
                //   var result = http.post(
                //       Uri.parse('https://tickets-sys.herokuapp.com/login'),
                //       body: {
                //         'email': _emailController.text,
                //         'password': _passwordController.text
                //       });
                // }
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
