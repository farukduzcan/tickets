import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import '../../../components/input_field.dart';
import '../../../components/password_input_field.dart';
import '../../../models/user_model.dart';
import '../../../services/create_category_services.dart';
import '../../../services/create_customer_services.dart';
import '../../Login/login_screen.dart';

class CreateCategoryBody extends StatefulWidget {
  const CreateCategoryBody({super.key});

  @override
  State<CreateCategoryBody> createState() => _CreateCategoryBodyState();
}

class _CreateCategoryBodyState extends State<CreateCategoryBody> {
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
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailHostController = TextEditingController();
  final TextEditingController _emailPortController = TextEditingController();
  final TextEditingController _emailUserNameController =
      TextEditingController();
  final TextEditingController _emailPasswordController =
      TextEditingController();
  final TextEditingController _emailSSLController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmpasswordController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _categoryNameFocusNode = FocusNode();
  final FocusNode _emailHostFocusNode = FocusNode();
  final FocusNode _emailPortFocusNode = FocusNode();
  final FocusNode _emailUserNameFocusNode = FocusNode();
  final FocusNode _emailPasswordFocusNode = FocusNode();
  int port = 0;
  bool? _emailSSL = false;

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
        title: Text(kCategoryCreateTitle),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Text("Kategori Oluştur", style: kTitleStyle),
            ),
            // Lottie.asset('assets/lottie/register_page.json',
            //     width: size.width * 0.50, repeat: false),
            //Email
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Hata ismi
                  InputField(
                      isValidator: true,
                      validateInputMessage: "Lütfen Kategori İsmi Giriniz",
                      controller: _categoryNameController,
                      focusnode: _categoryNameFocusNode,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      hintText: "Kategori İsmi Giriniz",
                      icon: Icons.category_outlined,
                      onChanged: (value) {}),
                  //Email
                  InputField(
                      isValidator: true,
                      validateInputMessage: "Lütfen E-Mail Giriniz",
                      controller: _emailController,
                      focusnode: _emailFocusNode,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: kEmailHintText,
                      icon: Icons.mail_outline_outlined,
                      onChanged: (value) {}),
                  //Email host
                  InputField(
                      isValidator: false,
                      controller: _emailHostController,
                      focusnode: _emailHostFocusNode,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: "E-Mail Host Giriniz",
                      icon: Icons.mark_email_read_outlined,
                      onChanged: (value) {}),

                  //Email Port
                  InputField(
                      isValidator: false,
                      controller: _emailPortController,
                      focusnode: _emailPortFocusNode,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      hintText: "E-Mail Port Giriniz",
                      icon: Icons.mail_lock_outlined,
                      onChanged: (value) {}),
                  //Email username
                  InputField(
                      isValidator: false,
                      controller: _emailUserNameController,
                      focusnode: _emailUserNameFocusNode,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: "E-Mail Kullanıcı Adı Giriniz",
                      icon: Icons.person_2_outlined,
                      onChanged: (value) {}),

                  //Email Şifre
                  RaundedPasswordField(
                    isValidator: false,
                    controller: _emailPasswordController,
                    focusnode: _emailPasswordFocusNode,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {},
                    hintText: "E-Mail Şifre Giriniz",
                  ),
                  //Email SSL
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_person_rounded,
                          color: kPrimaryColor,
                        ),
                        const Text(
                          "Email SSL: ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        Switch(
                            value: _emailSSL!,
                            onChanged: (value) {
                              setState(() {
                                _emailSSL = value;
                                _emailSSLController.text = value.toString();
                              });
                            }),
                      ],
                    ),
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
                    port = int.tryParse(_emailPortController.text) ?? 0;
                    _loadingBar();
                    CreateCategoryListServices createCustomerServices =
                        CreateCategoryListServices();
                    var result = await createCustomerServices.createCategory(
                      eMail: _emailController.text,
                      categoryName: _categoryNameController.text,
                      eMailHost: _emailHostController.text,
                      eMailPort: port,
                      eMailUserName: _emailUserNameController.text,
                      eMailPassword: _emailPasswordController.text,
                      eMailSsl: _emailSSL,
                    );
                    if (result!.result! > 0 && result.data == null) {
                      _loadingBar();

                      // ignore: use_build_context_synchronously
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Başarılı",
                        text:
                            "Kategori Oluşturma işlemi başarılı bir şekilde gerçekleşti.",
                        confirmBtnText: "Tamam",
                        onConfirmBtnTap: () {
                          _emailController.clear();
                          _categoryNameController.clear();
                          _emailHostController.clear();
                          _emailPortController.clear();
                          _emailUserNameController.clear();
                          _emailPasswordController.clear();
                          _emailSSLController.clear();

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
