import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/login_response_model.dart';
import 'package:tickets/services/global.dart';

//HTTP STATUS CODE
//json encode, decode neden nasıl yapılır,
//Model neden kullanılır
//Model nasıl kullanılır
//baraer token nedir
//baraer token nasıl kullanılır

class LoginServices {
  Future<LoginResponseModel?> login(
      {required String userName, required String password}) async {
    //var toBase64 = utf8.encode(password);
    final base64Str = base64.encode(password.codeUnits);
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}token');
      var result = await http.post(url,
          body: jsonEncode({"Username": userName, "Password": base64Str}),
          headers: {"Content-Type": "application/json; charset=utf-8"});
      return LoginResponseModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
