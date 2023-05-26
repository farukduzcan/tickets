import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/category_select_list.dart';
import 'package:tickets/services/global.dart';

import '../models/user_model.dart';

class CateGorySelectListServices {
  static bool? isTokenValid;
  Future<CategorySelectList?> categoryselect() async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/CategoryList');
      var result = await http.post(url,
          body: jsonEncode({
            "Query": "",
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        //print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        log("Kategori Services Token Aktiflik Durumu $isTokenValid");

        //print("token valid mi $isTokenValid");
        var resultJson = CategorySelectList.fromJson(json.decode(result.body));
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        log("Kategori Services Token Aktiflik Durumu $isTokenValid");

        //print("token valid mi $isTokenValid");
      }
      return CategorySelectList.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
