import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tickets/components/input_field.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/models/fogetpass_mail_model.dart';
import 'package:tickets/services/forgetpass_mail_services.dart';
import 'package:tickets/view/Login/components/forget_confirm_body.dart';
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
                      ForgetPassMailServices forgetPassMailServices =
                          ForgetPassMailServices();
                      var response = await forgetPassMailServices.sendMail(
                          eMail: _emailController.text);
                      if (response?.data != null) {
                        ForgetPassMailModel.resetPasswordCode = response?.data;
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ForgetConfirmBody(
                              confirmmailAddress: _emailController.text,
                            );
                          }),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        QuickAlert.show(
                            confirmBtnText: kOk,
                            context: context,
                            type: QuickAlertType.error,
                            title: "Hata",
                            text: response?.errors.errorToString() ??
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
