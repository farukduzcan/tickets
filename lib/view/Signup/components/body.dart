import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/already_account.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/models/register_response_model.dart';
import 'package:tickets/services/register_services.dart';
import 'package:tickets/view/Login/login_screen.dart';
import 'package:tickets/view/Signup/confirm_page.dart';
import '../../../components/input_field.dart';
import '../../../components/password_input_field.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmpasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _comfirmpasswordFocusNode = FocusNode();

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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //Email
                  InputField(
                      controller: _emailController,
                      focusnode: _emailFocusNode,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: kEmailHintText,
                      icon: Icons.mail_outline_outlined,
                      onChanged: (value) {}),
                  //İsim
                  InputField(
                      controller: _firstNameController,
                      focusnode: _firstNameFocusNode,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      hintText: kNameHintText,
                      icon: Icons.person,
                      onChanged: (value) {}),
                  //Soyisim
                  InputField(
                      controller: _lastNameController,
                      focusnode: _lastNameFocusNode,
                      autofillHints: const [AutofillHints.familyName],
                      textInputAction: TextInputAction.next,
                      hintText: kSurnameHintText,
                      icon: Icons.person,
                      onChanged: (value) {}),
                  //Telefon
                  InputField(
                      controller: _phoneNumberController,
                      focusnode: _phoneNumberFocusNode,
                      inputFormatters: [
                        MaskTextInputFormatter(mask: "(###) ### ## ##)"),
                      ],
                      autofillHints: const [AutofillHints.telephoneNumber],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      hintText: kPhoneHintText,
                      icon: Icons.phone_android_outlined,
                      onChanged: (value) {}),
                  //Firma Ünvanı
                  InputField(
                      controller: _companyNameController,
                      focusnode: _companyNameFocusNode,
                      autofillHints: const [AutofillHints.jobTitle],
                      textInputAction: TextInputAction.next,
                      hintText: kCompanyName,
                      icon: Icons.business_outlined,
                      onChanged: (value) {}),
                  //Şifre
                  RaundedPasswordField(
                    controller: _passwordController,
                    focusnode: _passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {},
                    hintText: kPasswordHintText,
                  ),
                  //Şifre Tekrar
                  RaundedPasswordField(
                    controller: _comfirmpasswordController,
                    focusnode: _comfirmpasswordFocusNode,
                    onChanged: (value) {},
                    hintText: kPasswordHintText,
                  ),
                ],
              ),
            ),
            RaundedButton(
              isLoading: loading,
              loadingText: kRegisterLoadingText,
              buttonText: kRegisterButtonTitle,
              press: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  try {
                    _loadingBar();
                    RegisterServices registerServices = RegisterServices();
                    var result = await registerServices.register(
                      companyName: _companyNameController.text,
                      eMail: _emailController.text,
                      firsName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      password: _passwordController.text,
                      confirmPassword: _comfirmpasswordController.text,
                    );
                    if (result != null && result.data != null) {
                      RegisterResponseModel.confirmationCode = result.data!;
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ConfirmPage(
                            mailAddress: _emailController.text,
                          );
                        }),
                      );
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     backgroundColor: Colors.red,
                      //     content: Text(result?.errors.errorToString() ??
                      //         "Beklenmeyen bir hata oluştu!."),
                      //   ),
                      // );
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
