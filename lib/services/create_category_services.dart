import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/register_response_model.dart';
import '../models/user_model.dart';

class CreateCategoryListServices {
  static bool? isTokenValid;
  Future<RegisterResponseModel?> createCategory({
    required String eMail,
    required String categoryName,
    String? eMailHost,
    int eMailPort = 0,
    String? eMailUserName,
    String? eMailPassword,
    bool? eMailSsl,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}client/category/create');
      var result = await http.post(url,
          body: jsonEncode({
            "Name": categoryName,
            "Email": eMail,
            "EmailHost": eMailHost,
            "EmailPort": eMailPort,
            "EmaiUserName": eMailUserName,
            "EmailPassword": eMailPassword,
            "EmailSsl": eMailSsl
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        //print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        log("Category Create Token Aktiflik Durumu $isTokenValid");
        // print("token valid mi $isTokenValid");
        var resultJson =
            RegisterResponseModel.fromJson(json.decode(result.body));
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        log("Category Create Token Aktiflik Durumu $isTokenValid");

        // print("token valid mi $isTokenValid");
      }
      return RegisterResponseModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
