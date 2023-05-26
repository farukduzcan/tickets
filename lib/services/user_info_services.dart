import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';

import '../models/user_model.dart';

class UserInfoServices {
  static bool isTokenValid = false;
  Future<UserModel?> user() async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}account/info');
      var result = await http.post(url, headers: {
        "Authorization": "Bearer ${UserModel.userToken}",
        "Content-Type": "application/json; charset=utf-8"
      });
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        // print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        // print("token valid mi $isTokenValid");
        log("Kullanıcı Bilgileri Token Aktiflik Durumu $isTokenValid");

        var resultJson = UserModel.fromJson(json.decode(result.body));
        saveUserData(resultJson.data!);
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        log("Kullanıcı Bilgileri Token Aktiflik Durumu $isTokenValid");

        // print("token valid mi $isTokenValid");
      }
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
    return null;
  }
}
