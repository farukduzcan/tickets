import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/already_account.dart';
import 'package:tickets/components/input_field.dart';
import 'package:tickets/components/password_input_field.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/services/login_services.dart';
import 'package:tickets/view/Signup/signup_screen.dart';
import '../../../components/background.dart';

import '../../../models/user_model.dart';
import '../../Dashboard/dashboard_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: "osman.buran@veri.plus");
  final TextEditingController _passwordController =
      TextEditingController(text: "Mert29%OB");
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
              press: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  {
                    LoginServices loginServices = LoginServices();
                    var result = await loginServices.login(
                        userName: _emailController.text,
                        password: _passwordController.text);
                    if (result != null && result.data != null) {
                      UserModel.userToken = result.data!.token;
                      //TOKEN BİLGİSİ İLE USER INFO ÇEK.
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const DashboardScreen();
                        }),
                      );
                    }
                  }
                }
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
