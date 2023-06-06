// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/services/reset_password_services.dart';

import '../../../components/background.dart';
import '../../../components/password_input_field.dart';
import '../../../models/fogetpass_mail_model.dart';
import '../login_screen.dart';

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
                    try {
                      ResetPasswordServices resetPasswordServices =
                          ResetPasswordServices();
                      var result = await resetPasswordServices.resetPassword(
                          eMail: widget.email,
                          newPassword: _passwordController.text,
                          confimCode:
                              ForgetPassMailModel.resetPasswordCode.toString());
                      if (result?.data == null) {
                        // ignore: use_build_context_synchronously
                        QuickAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: QuickAlertType.success,
                            title: kAlertSuccssesTitle,
                            text: kResetPasswordSuccess,
                            confirmBtnText: kLoginButtonTitle,
                            onConfirmBtnTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) =>
                                    false, // Geri tuşuna basıldığında hiçbir sayfa kalmadığı için false döndür
                              );
                            });
                      } else {
                        // ignore: use_build_context_synchronously
                        QuickAlert.show(
                            confirmBtnText: kOk,
                            context: context,
                            type: QuickAlertType.error,
                            title: "Hata",
                            text: result?.errors.errorToString() ??
                                "Beklenmeyen bir hata oluştu!.");
                      }
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
