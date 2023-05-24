import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class TopMessageBar extends StatelessWidget {
  final String? message;
  const TopMessageBar({Key? key, required this.message}) : super(key: key);

  void showTopMessage(BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(10),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      backgroundGradient: LinearGradient(
        colors: List.of([Colors.green, Colors.green.shade400]),
      ),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      barBlur: 0.50,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      flushbarPosition: FlushbarPosition.TOP,
      message: message ?? "Başarılı",
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  void showTopMessageError(BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(10),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      backgroundGradient: LinearGradient(
        colors: List.of([Colors.red, Colors.red.shade400]),
      ),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      barBlur: 0.50,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      flushbarPosition: FlushbarPosition.TOP,
      message: message ?? "Başarısız",
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  void showTopMessageBarsuccessful(BuildContext context) {
    showTopMessage(context);
  }

  void showTopMessageBarError(BuildContext context) {
    showTopMessageError(context);
  }

  @override
  Widget build(BuildContext context) {
    // Bu widget boş olduğu için null döndürüyoruz
    return const SizedBox();
  }
}
