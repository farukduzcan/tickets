import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/already_account.dart';
import 'package:tickets/components/input_field.dart';
import 'package:tickets/components/messenger_bar_top.dart';
import 'package:tickets/components/password_input_field.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/home.dart';
import 'package:tickets/services/login_services.dart';
import 'package:tickets/view/Login/forgetpass_screen.dart';
import 'package:tickets/view/Signup/signup_screen.dart';
import '../../../components/background.dart';
import '../../../models/user_model.dart';
import '../../../services/user_info_services.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
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
          Text(kLoginTitle, style: kTitleStyle),
          Lottie.asset(AssetsConstant.loginPage,
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
          Padding(
            padding: const EdgeInsets.only(right: 45, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ForgetPassScreen();
                      }),
                    );
                  },
                  child: Text(
                    kForgotPassword,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaundedButton(
              loadingText: kLoginLoadingText,
              isLoading: loading,
              buttonText: kLoginButtonTitle,
              press: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  {
                    try {
                      _loadingBar();

                      LoginServices loginServices = LoginServices();
                      var result = await loginServices.login(
                          userName: _emailController.text,
                          password: _passwordController.text);

                      if (result?.errors != null) {
                        // ignore: use_build_context_synchronously
                        TopMessageBar(
                          message: result!.errors.errorToString(),
                        ).showTopMessageBarError(context);
                      }

                      if (result != null && result.data != null) {
                        UserModel.userToken = result.data!.token;
                        await setToken(result.data!.token);
                        UserInfoServices userInfoServices = UserInfoServices();
                        // ignore: unused_local_variable
                        var response = await userInfoServices.user();

                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }),
                        );
                      }
                      _loadingBar();
                    } catch (e) {
                      TopMessageBar(
                        message: e.toString(),
                      ).showTopMessageBarError(context);
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
