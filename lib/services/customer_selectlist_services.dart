import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/customer_selectlist_model.dart';
import 'package:tickets/services/global.dart';
import '../models/user_model.dart';

class CustomerSelectListServices {
  Future<CustomerSelectListModel?> customerList() async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}client/customer/selectList');
      var result = await http.post(url, body: jsonEncode({}), headers: {
        "Authorization": "Bearer ${UserModel.userToken}",
        "Content-Type": "application/json; charset=utf-8"
      });
      return CustomerSelectListModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
