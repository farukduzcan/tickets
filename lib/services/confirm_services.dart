import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/confirm_model.dart';
import 'package:tickets/services/global.dart';

class ConfirmServices {
  Future<ConfirmModel?> confirm({
    required String code,
    required String eMail,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}accountConfirm');
      var result = await http.post(url,
          body: jsonEncode({
            "Email": eMail,
            "Code": code,
          }),
          headers: {"Content-Type": "application/json; charset=utf-8"});
      return ConfirmModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
