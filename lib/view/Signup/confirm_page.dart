import 'package:flutter/material.dart';
import 'package:tickets/view/Signup/components/confirm_body.dart';

class ConfirmPage extends StatelessWidget {
  final String mailAddress;
  const ConfirmPage({super.key, required this.mailAddress});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 121), () {
      Navigator.pop(context);
    });
    return Scaffold(
      body: ConfirmBody(mailAddress: mailAddress),
    );
  }
}
