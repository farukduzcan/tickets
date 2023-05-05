import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/reset_password_model.dart';

class ResetPasswordServices {
  Future<ResetPassword?> resetPassword(
      {required String eMail,
      required String confimCode,
      required String newPassword}) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}resetPassword');
      var result = await http.post(url,
          body: jsonEncode({
            "Username": eMail,
            "Password": newPassword,
            "Code": confimCode,
          }),
          headers: {"Content-Type": "application/json; charset=utf-8"});
      return ResetPassword.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
