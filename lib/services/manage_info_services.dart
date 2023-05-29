import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/manage_info_model.dart';
import 'package:tickets/services/global.dart';

import '../models/user_model.dart';

class ManageInfoServices {
  static bool? isTokenValid;
  Future<ManageInfoModel?> manageinfo() async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}client/manage/info');
      var result = await http.post(url, headers: {
        "Authorization": "Bearer ${UserModel.userToken}",
        "Content-Type": "application/json; charset=utf-8"
      });
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        // print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        // print("token valid mi $isTokenValid");
        log("Manage İnfo Token Aktiflik Durumu $isTokenValid");

        var resultJson = ManageInfoModel.fromJson(json.decode(result.body));
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        log("Manage İnfo Token Aktiflik Durumu $isTokenValid");

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
