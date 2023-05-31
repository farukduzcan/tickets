import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/services/change_password_services.dart';
import '../../../components/password_input_field.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({super.key});

  @override
  State<ChangePasswordBody> createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmpasswordController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _comfirmpasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: kPrimaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(29),
            bottomRight: Radius.circular(29),
          ),
        ),
        backgroundColor: kPrimaryColor,
        title: const Text("Şifre Değiştir"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
            ),
            Lottie.asset(
              'assets/lottie/change-passwords.json',
              width: size.width * 0.50,
              repeat: false,
            ),
            //Email
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //Şifre
                  RaundedPasswordField(
                    color: Colors.white,
                    controller: _passwordController,
                    focusnode: _passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {},
                    hintText: kPasswordHintText,
                  ),
                  //Şifre Tekrar
                  RaundedPasswordField(
                    color: Colors.white,
                    controller: _comfirmpasswordController,
                    focusnode: _comfirmpasswordFocusNode,
                    onChanged: (value) {},
                    hintText: "Şifre Tekrar",
                  ),
                ],
              ),
            ),
            RaundedButton(
              isLoading: loading,
              loadingText: "Şifre Değiştiriliyor...",
              buttonText: "Şifre Değiştir",
              press: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    _loadingBar();
                    ChangePasswordServices changePass =
                        ChangePasswordServices();
                    var result = await changePass.changePassword(
                      password: _passwordController.text,
                      confirmPassword: _comfirmpasswordController.text,
                    );
                    if (result != null &&
                        result.data == null &&
                        result.result!.isNegative == false) {
                      _loadingBar();

                      // ignore: use_build_context_synchronously
                      QuickAlert.show(
                          confirmBtnText: kOk,
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          context: context,
                          type: QuickAlertType.success,
                          title: "Başarılı",
                          text: "Şifreniz başarıyla değiştirildi.");
                    } else {
                      _loadingBar();
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
