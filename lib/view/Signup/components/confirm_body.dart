import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/constants.dart';
import 'package:pinput/pinput.dart';
import 'package:tickets/models/register_response_model.dart';

import '../../../services/confirm_services.dart';
import '../../Login/login_screen.dart';

class ConfirmBody extends StatefulWidget {
  final String mailAddress;
  const ConfirmBody({super.key, required this.mailAddress});

  @override
  State<ConfirmBody> createState() => _ConfirmBodyState();
}

class _ConfirmBodyState extends State<ConfirmBody> {
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

  int _counter = 120;

  void _timerCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginAndRegisterBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(kConfirmTitle, style: kTitleStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              child: Text(
                kConfirmSubtitle,
                style: const TextStyle(
                  color: Color.fromRGBO(111, 121, 129, 1),
                ),
              ),
            ),
            Lottie.asset('assets/lottie/otp_verification.json',
                width: size.width * 0.50, repeat: false),
            Pinput(
              toolbarEnabled: true,
              length: 6,
              closeKeyboardWhenCompleted: true,
              autofocus: true,
              defaultPinTheme: defaultPinTheme,
              validator: (s) {
                return s == RegisterResponseModel.confirmationCode
                    ? null
                    : kConfirincorrect;
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) async {
                if (pin == RegisterResponseModel.confirmationCode) {
                  ConfirmServices confirmServices = ConfirmServices();
                  var response = await confirmServices.confirm(
                      code: pin, eMail: widget.mailAddress);
                  if (response!.result!.isNegative == false) {
                    // ignore: use_build_context_synchronously
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: kAlertSuccssesTitle,
                      text: kConfirmSuccess,
                      confirmBtnText: kOk,
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }),
                        );
                      },
                    );
                  }
                }

                //print(widget.mailAddress);
              },
            ),
            Text("Kalan Süre: $_counter sn",
                style: const TextStyle(fontSize: 20, color: Colors.red)),
            // RaundedButton(
            //     buttonText: "KOD",
            //     press: () {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //         content: Text(
            //             "Onay Kodunuz: ${RegisterResponseModel.confirmationCode.toString()}"),
            //         backgroundColor: Colors.red,
            //       ));
            //     }),
          ],
        ),
      ),
    );
  }
}
