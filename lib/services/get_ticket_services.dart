import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/get_ticket_model.dart';
import '../models/user_model.dart';

class GetTicketServices {
  Future<GetTicketModel?> getItem({
    required String id,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/item/$id');
      var result = await http.post(url, headers: {
        "Authorization": "Bearer ${UserModel.userToken}",
        "Content-Type": "application/json; charset=utf-8"
      });
      return GetTicketModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
