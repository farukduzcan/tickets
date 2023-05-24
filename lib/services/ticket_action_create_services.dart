import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/services/global.dart';
import '../models/ticket_action_create_model.dart';
import '../models/user_model.dart';

class TicketActionCreateServices {
  Future<TicketActionCreateModel?> setActionCreate({
    required int ticketId,
    required String body,
    required String actionStatus,
    int? categoryId,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/action/create');
      var result = await http.post(url,
          body: jsonEncode({
            "TicketId": ticketId,
            "Body": body,
            "ActionStatus": actionStatus,
            "CategoryId": categoryId,
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      return TicketActionCreateModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
