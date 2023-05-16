import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/ticket_list_model.dart';
import 'package:tickets/services/global.dart';
import '../models/user_model.dart';

class TicketListServices {
  Future<TicketListModel?> getTicketList({
    required int pageIndex,
    int pageSize = 15,
    String orderField = "Id",
    String orderDir = "ASC",
    required String filter,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/list');
      var result = await http.post(url,
          body: jsonEncode({
            "PageIndex": pageIndex,
            "PageSize": pageSize,
            "OrderField": orderField,
            "OrderDir": orderDir,
            "Filter": ""
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      return TicketListModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
