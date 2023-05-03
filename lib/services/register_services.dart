import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/register_response_model.dart';

class RegisterServices {
  Future<RegisterResponseModel?> register(
      {required String firsName,
      required String lastName,
      required String companyName,
      required String eMail,
      required String confirmPassword,
      required String password}) async {
    //final base64Str = base64.encode(password.codeUnits);
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}client/register');
      var result = await http.post(url,
          body: jsonEncode({
            "CompanyName": companyName,
            "FirstName": firsName,
            "LastName": lastName,
            "Email": eMail,
            "Password": password,
            "ConfirmPassword": confirmPassword,
          }),
          headers: {"Content-Type": "application/json; charset=utf-8"});
      return RegisterResponseModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
