import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/ticket_list_model.dart';
import 'package:tickets/services/global.dart';
import '../models/user_model.dart';

class TicketListServices {
  static bool isTokenValid = false;
  Future<TicketListModel?> getTicketList({
    required int pageIndex,
    int pageSize = 15,
    String orderField = "Id",
    String orderDir = "DESC",
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
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        //print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        log("Ticket List Token Aktiflik Durumu $isTokenValid");
        // print("token valid mi $isTokenValid");
        var resultJson = TicketListModel.fromJson(json.decode(result.body));
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        log("Ticket List Token Aktiflik Durumu $isTokenValid");

        // print("token valid mi $isTokenValid");
      }
      return TicketListModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
