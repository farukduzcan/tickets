import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';

import '../models/fogetpass_mail_model.dart';

class ForgetPassMailServices {
  Future<ForgetPassMailModel?> sendMail({
    required String eMail,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}forgetPassword');
      var result = await http.post(url,
          body: jsonEncode({
            "Username": eMail,
          }),
          headers: {"Content-Type": "application/json; charset=utf-8"});
      return ForgetPassMailModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
