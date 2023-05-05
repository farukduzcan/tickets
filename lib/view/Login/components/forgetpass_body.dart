import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/input_field.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/view/Login/forget_confirm_screen.dart';
import '../../../components/background.dart';

class ForgetPassBody extends StatefulWidget {
  const ForgetPassBody({super.key});

  @override
  State<ForgetPassBody> createState() => _ForgetPassBodyState();
}

class _ForgetPassBodyState extends State<ForgetPassBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

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
            padding: const EdgeInsets.all(8.0),
            child: Text(kForgotPassword, style: kTitleStyle),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(kForgotPasswordSubTitle,
                style:
                    const TextStyle(color: Color.fromRGBO(111, 121, 129, 1))),
          ),
          Lottie.asset('assets/lottie/forgot_password.json',
              width: size.width * 0.45, repeat: true),
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
              ],
            ),
          ),
          RaundedButton(
              loadingText: kForgotPasswordLoadingText,
              isLoading: loading,
              buttonText: kForgotPasswordSendCode,
              press: () async {
                _loadingBar();
                if (_formKey.currentState?.validate() ?? false) {
                  {
                    try {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const ForgetConfirmPage(
                            mailAddress: "faruk_duzcan@hotmail.com",
                          );
                        }),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                  _loadingBar();
                }
              }),
        ],
      ),
    ));
  }
}
