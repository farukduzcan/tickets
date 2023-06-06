import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../constants.dart';
import '../models/user_model.dart';
import '../services/ticket_list_services.dart';
import '../view/Login/login_screen.dart';

class TokenValidation {
  tokenValid(BuildContext context, bool? isTokenValid) async {
    if (isTokenValid != null) {
      if (isTokenValid == false) {
        QuickAlert.show(
          context: context,
          barrierDismissible: false,
          type: QuickAlertType.error,
          title: QuickAlertConstant.warning,
          text: QuickAlertConstant.logoutTimeoutMessage,
          confirmBtnText: QuickAlertConstant.ok,
          onConfirmBtnTap: () async {
            await deleteToken();
            await deleteUserData();

            TicketListServices.isTokenValid = null;
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) =>
                  false, // Geri tuşuna basıldığında hiçbir sayfa kalmadığı için false döndür
            );
          },
        );
      }
    }
  }
}
