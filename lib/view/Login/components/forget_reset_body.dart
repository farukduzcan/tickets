// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';

import '../../../components/background.dart';
import '../../../components/password_input_field.dart';

class ForgetResetBody extends StatefulWidget {
  final String email;
  const ForgetResetBody({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgetResetBody> createState() => _ForgetResetBodyState();
}

class _ForgetResetBodyState extends State<ForgetResetBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

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
            child: Text(kForgetResetTitle, style: kTitleStyle),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(kForgetResetSubtitle,
                style:
                    const TextStyle(color: Color.fromRGBO(111, 121, 129, 1))),
          ),
          Lottie.asset('assets/lottie/reset_password.json',
              width: size.width * 0.35, repeat: true),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
              loadingText: kForgetResetLoadingText,
              isLoading: loading,
              buttonText: kForgetResetButton,
              press: () async {
                _loadingBar();
                if (_formKey.currentState?.validate() ?? false) {
                  {
                    try {} catch (e) {
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
