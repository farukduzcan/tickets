import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tickets/constants.dart';
import 'package:tickets/models/create_ticket_model.dart';
import 'package:tickets/services/global.dart';
import '../models/user_model.dart';

class CreateTicketServices {
  static bool? isTokenValid;
  static int? fileUploadId;
  Future<CreateTicketModel?> create({
    required String body,
    required String subject,
    required int categoryId,
    required int customerId,
  }) async {
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}ticket/create');
      var result = await http.post(url,
          body: jsonEncode({
            "Body": body,
            "Subject": subject,
            "categoryId": categoryId,
            "CustomerId": customerId,
          }),
          headers: {
            "Authorization": "Bearer ${UserModel.userToken}",
            "Content-Type": "application/json; charset=utf-8"
          });
      //data hatasızsa bu işlemi yap
      if (result.statusCode == 200) {
        //print("Statü Kodu $result.statusCode");
        isTokenValid = true;
        //print("token valid mi $isTokenValid");
        var resultJson = CreateTicketModel.fromJson(json.decode(result.body));
        return resultJson;
      }
      if (result.statusCode == 401) {
        isTokenValid = false;
        //print("token valid mi $isTokenValid");
      }
      return CreateTicketModel.fromJson(json.decode(result.body));
    } on SocketException {
      throw Exception(kLoginErrorEthernet);
    } catch (e) {
      throw Exception("$kErrorTitle, $e");
    }
  }
}
