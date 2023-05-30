import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/delete_ticket_model.dart';
import 'package:tickets/services/global.dart';
import '../models/user_model.dart';

class DeleteCategoryServices {
  Future<DeleteTicketModel?> deleteCategory({
    required String id,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}client/category/delete/$id');
      var result = await http.post(url, headers: {
        "Authorization": "Bearer ${UserModel.userToken}",
        "Content-Type": "application/json; charset=utf-8"
      });
      return DeleteTicketModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
