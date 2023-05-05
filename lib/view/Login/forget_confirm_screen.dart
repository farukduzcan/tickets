import 'package:flutter/material.dart';
import 'components/forget_confirm_body.dart';

class ForgetConfirmPage extends StatelessWidget {
  final String mailAddress;
  const ForgetConfirmPage({super.key, required this.mailAddress});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 121), () {
      Navigator.pop(context);
    });
    return Scaffold(
      body: ForgetConfirmBody(confirmmailAddress: mailAddress),
    );
  }
}
