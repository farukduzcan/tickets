import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import '../../../components/input_field.dart';
import '../../../components/password_input_field.dart';
import '../../../models/user_model.dart';
import '../../../services/create_customer_services.dart';
import '../../Login/login_screen.dart';

class CreateCustomerBody extends StatefulWidget {
  const CreateCustomerBody({super.key});

  @override
  State<CreateCustomerBody> createState() => _CreateCustomerBodyState();
}

class _CreateCustomerBodyState extends State<CreateCustomerBody> {
  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  void initState() {
    tokenValid();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmpasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _comfirmpasswordFocusNode = FocusNode();

  tokenValid() async {
    if (CreateCustomerServices.isTokenValid == false) {
      QuickAlert.show(
        context: context,
        barrierDismissible: false,
        type: QuickAlertType.error,
        title: "Uyarı",
        text: "Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.",
        confirmBtnText: kOk,
        onConfirmBtnTap: () async {
          await deleteToken();
          CreateCustomerServices.isTokenValid = null;
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Size size = MediaQuery.of(context).size;
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
        title: Text(kCustomerCreateTitle),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(kCustomerCreateTitle, style: kTitleStyle),
            ),
            // Lottie.asset('assets/lottie/register_page.json',
            //     width: size.width * 0.50, repeat: false),
            //Email
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    CreateCustomerServices createCustomerServices =
                        CreateCustomerServices();
                    var result = await createCustomerServices.createCustomer(
                      eMail: _emailController.text,
                      firsName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      password: _passwordController.text,
                      confirmPassword: _comfirmpasswordController.text,
                    );
                    if (result!.result! > 0 && result.data == null) {
                      _loadingBar();

                      // ignore: use_build_context_synchronously
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Başarılı",
                        text:
                            "Müşteri Kayıt işlemi başarılı bir şekilde gerçekleşti.",
                        confirmBtnText: "Tamam",
                        onConfirmBtnTap: () {
                          _emailController.clear();
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _passwordController.clear();
                          _comfirmpasswordController.clear();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      _loadingBar();
                      // ignore: use_build_context_synchronously
                      QuickAlert.show(
                          confirmBtnText: kOk,
                          context: context,
                          type: QuickAlertType.error,
                          title: "Hata",
                          text: result.errors.errorToString());
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
            const Divider(
              height: 0,
              thickness: 0,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}
