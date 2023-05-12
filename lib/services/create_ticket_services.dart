import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/create_ticket_model.dart';
import 'package:tickets/services/global.dart';
import '../models/user_model.dart';

class CreateTicketServices {
  static int? fileUploadId;
  Future<CreateTicketModel?> create({
    required String body,
    required String subject,
    required int categoryId,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/create');
      var result = await http.post(url,
          body: jsonEncode({
            "Body": body,
            "Subject": subject,
            "categoryId": categoryId,
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      return CreateTicketModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
