import 'package:flutter/material.dart';
import 'package:tickets/view/Login/components/forgetpass_body.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ForgetPassBody(),
    );
  }
}
