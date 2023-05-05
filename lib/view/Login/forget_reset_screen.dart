import 'package:flutter/material.dart';
import 'package:tickets/view/Login/components/forget_reset_body.dart';

class ForgetResetPage extends StatelessWidget {
  final String mailAddress;
  const ForgetResetPage({super.key, required this.mailAddress});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ForgetResetBody(email: "faruk_duzcan@hotmail.com"),
    );
  }
}
