import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/register_response_model.dart';
import '../models/user_model.dart';

class CreateCustomerServices {
  static bool? isTokenValid;

  Future<RegisterResponseModel?> createCustomer(
      {required String firsName,
      required String lastName,
      required String eMail,
      required String confirmPassword,
      required String password}) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}client/customer/create');
      var result = await http.post(url,
          body: jsonEncode({
            "Email": eMail,
            "FirstName": firsName,
            "LastName": lastName,
            "Password": password,
            "ConfirmPassword": confirmPassword
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        //print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        log("Create Customer Token Aktiflik Durumu $isTokenValid");
        // print("token valid mi $isTokenValid");
        var resultJson =
            RegisterResponseModel.fromJson(json.decode(result.body));
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        log("Create Customer Token Aktiflik Durumu $isTokenValid");

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
