// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import 'package:tickets/components/background.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/models/fogetpass_mail_model.dart';
import 'package:tickets/view/Login/forget_reset_screen.dart';

import '../login_screen.dart';

class ForgetConfirmBody extends StatefulWidget {
  final String confirmmailAddress;
  const ForgetConfirmBody({
    Key? key,
    required this.confirmmailAddress,
  }) : super(key: key);

  @override
  State<ForgetConfirmBody> createState() => _ForgetConfirmBodyState();
}

class _ForgetConfirmBodyState extends State<ForgetConfirmBody> {
  bool loading = false;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  bool timerisactive = true;
  int _counter = 120;
  late Timer _timerconfirm;

  void _timerCounter() {
    if (timerisactive == true) {
      setState(() {
        _counter--;
        _counter <= 0 ? timerisactive = false : timerisactive = true;
      });
    } else if (timerisactive == false) {
      _timerconfirm.cancel();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timerconfirm = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: LoginAndRegisterBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(kForgetConfirmTitle, style: kTitleStyle),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                child: Text(
                  kForgetConfirmSubtitle,
                  style: const TextStyle(
                    color: Color.fromRGBO(111, 121, 129, 1),
                  ),
                ),
              ),
              Text("Kalan Süre: $_counter sn",
                  style: const TextStyle(fontSize: 20, color: Colors.red)),
              Lottie.asset('assets/lottie/otp_verification.json',
                  width: size.width * 0.50, repeat: false),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Pinput(
                  toolbarEnabled: true,
                  length: 6,
                  closeKeyboardWhenCompleted: true,
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  validator: (s) {
                    return s == ForgetPassMailModel.resetPasswordCode
                        ? null
                        : kConfirincorrect;
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) async {
                    if (pin == ForgetPassMailModel.resetPasswordCode) {
                      setState(() {
                        timerisactive = false;
                      });
                      _timerconfirm.cancel();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetResetPage(
                                  mailAddress: widget.confirmmailAddress,
                                )),
                        (route) =>
                            false, // Geri tuşuna basıldığında hiçbir sayfa kalmadığı için false döndür
                      );
                    }

                    //print(widget.mailAddress);
                  },
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: RaundedButton(
              //       buttonText: "KOD",
              //       press: () {
              //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //           content: Text(
              //               "Onay Kodunuz: ${ForgetPassMailModel.resetPasswordCode.toString()}"),
              //           backgroundColor: Colors.red,
              //         ));
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
