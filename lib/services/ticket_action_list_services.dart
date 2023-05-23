import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/ticket_aciton_list_model.dart';
import '../models/user_model.dart';

class TicketActionListServices {
  Future<TicketActionListModel?> getTicketActionList({
    required int pageIndex,
    int? pageSize,
    String orderField = "Id",
    String orderDir = "ASC",
    required int ticketId,
    required String filter,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/action/list/');
      var result = await http.post(url,
          body: jsonEncode({
            "PageIndex": pageIndex,
            "PageSize": pageSize ?? 10,
            "OrderField": orderField,
            "OrderDir": orderDir,
            "Filter": "",
            "Id": ticketId
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      return TicketActionListModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
