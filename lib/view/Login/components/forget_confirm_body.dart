import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/constants.dart';
import 'package:pinput/pinput.dart';
import 'package:tickets/models/register_response_model.dart';
import 'package:tickets/view/Login/forget_reset_screen.dart';

class ForgetConfirmBody extends StatefulWidget {
  final String mailAddress;
  const ForgetConfirmBody({super.key, required this.mailAddress});

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

  final int _counter = 120;
  // final bool _counterActive = true;

  // void _timerCounter() {
  //   setState(() {
  //     _counter--;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     _counterActive ? _timerCounter() : timer.cancel();
  //   });
  // }

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
              child: Text(kForgetConfirmTitle, style: kTitleStyle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              child: Text(
                kForgetConfirmSubtitle,
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
                return s == "123456" ? null : kConfirincorrect;
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) async {
                if (pin == "123456") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const ForgetResetPage(
                        mailAddress: "faruk_duzcan@hotmail.com",
                      );
                    }),
                  );
                }

                //print(widget.mailAddress);
              },
            ),
            Text("Kalan Süre: $_counter sn",
                style: const TextStyle(fontSize: 20, color: Colors.red)),
            RaundedButton(
                buttonText: "KOD",
                press: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Onay Kodunuz: ${RegisterResponseModel.confirmationCode.toString()}"),
                    backgroundColor: Colors.red,
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
