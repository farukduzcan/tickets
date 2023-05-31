import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/services/update_profile_services.dart';
import '../../../components/input_field.dart';
import '../../../models/user_model.dart';
import '../../../services/user_info_services.dart';

class UpdateProfileBody extends StatefulWidget {
  const UpdateProfileBody({super.key});

  @override
  State<UpdateProfileBody> createState() => _UpdateProfileBodyState();
}

class _UpdateProfileBodyState extends State<UpdateProfileBody> {
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

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  @override
  void initState() {
    _emailController.text = UserModel.userData!.email!;
    _firstNameController.text = UserModel.userData!.firstName!;
    _lastNameController.text = UserModel.userData!.lastName!;
    super.initState();
  }

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
        title: Text(kUpdateProfileTitle),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 40),
            //   child: Text(kUpdateProfileTitle, style: kTitleStyle),
            // ),
            Lottie.asset('assets/lottie/editprofile.json',
                width: size.width * 0.50, repeat: false),
            //Email
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //Email
                  InputField(
                      color: Colors.white,
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
                      color: Colors.white,
                      controller: _firstNameController,
                      focusnode: _firstNameFocusNode,
                      autofillHints: const [AutofillHints.name],
                      textInputAction: TextInputAction.next,
                      hintText: kNameHintText,
                      icon: Icons.person,
                      onChanged: (value) {}),
                  //Soyisim
                  InputField(
                      color: Colors.white,
                      controller: _lastNameController,
                      focusnode: _lastNameFocusNode,
                      autofillHints: const [AutofillHints.familyName],
                      textInputAction: TextInputAction.next,
                      hintText: kSurnameHintText,
                      icon: Icons.person,
                      onChanged: (value) {}),
                ],
              ),
            ),
            RaundedButton(
              isLoading: loading,
              loadingText: "Kaydediliyor...",
              buttonText: "Kaydet",
              press: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_emailController.text == UserModel.userData!.email &&
                      _firstNameController.text ==
                          UserModel.userData!.firstName &&
                      _lastNameController.text ==
                          UserModel.userData!.lastName) {
                    QuickAlert.show(
                        confirmBtnText: kOk,
                        context: context,
                        type: QuickAlertType.info,
                        title: "Bilgi",
                        text: "Değişiklik yapmadınız.");
                    return;
                  } else {
                    try {
                      _loadingBar();
                      UpdateProfileServices updateProfile =
                          UpdateProfileServices();
                      var result = await updateProfile.updateProfile(
                        eMail: _emailController.text,
                        firsName: _firstNameController.text,
                        lastName: _lastNameController.text,
                      );
                      if (result != null &&
                          result.data == null &&
                          result.result!.isNegative == false) {
                        _loadingBar();
                        // ignore: use_build_context_synchronously
                        QuickAlert.show(
                            confirmBtnText: kOk,
                            onConfirmBtnTap: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              UserInfoServices userInfoServices =
                                  UserInfoServices();
                              // ignore: unused_local_variable
                              var response = await userInfoServices.user();
                            },
                            context: context,
                            type: QuickAlertType.success,
                            title: "Başarılı",
                            text: "Profiliniz başarıyla güncellendi.");
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
