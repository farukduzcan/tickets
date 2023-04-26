import 'package:flutter/material.dart';

import '../../../components/input_field.dart';
import '../../../components/password_input_field.dart';
import '../../../constants.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputField(
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              hintText: kEmailHintText,
              icon: Icons.mail_outline_outlined,
              onChanged: (value) {}),
          //İsim
          InputField(
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              hintText: kNameHintText,
              icon: Icons.person,
              onChanged: (value) {}),
          //Soyisim
          InputField(
              autofillHints: const [AutofillHints.familyName],
              textInputAction: TextInputAction.next,
              hintText: kSurnameHintText,
              icon: Icons.person,
              onChanged: (value) {}),
          //Telefon
          InputField(
              autofillHints: const [AutofillHints.telephoneNumber],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              hintText: kPhoneHintText,
              icon: Icons.phone_android_outlined,
              onChanged: (value) {}),
          //Firma Ünvanı
          InputField(
              autofillHints: const [AutofillHints.jobTitle],
              textInputAction: TextInputAction.next,
              hintText: kCompanyName,
              icon: Icons.business_outlined,
              onChanged: (value) {}),
          //Şifre
          RaundedPasswordField(
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
            hintText: kPasswordHintText,
          ),
          //Şifre Tekrar
          RaundedPasswordField(
            onChanged: (value) {},
            hintText: kPasswordHintText,
          ),
        ],
      ),
    );
  }
}
