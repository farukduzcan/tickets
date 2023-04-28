import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tickets/models/login_response_model.dart';
import 'package:tickets/services/global.dart';

//HTTP STATUS CODE
//json encode, decode neden nasıl yapılır,
//Model neden kullanılır
//Model nasıl kullanılır
//baraer token nedir
//baraer token nasıl kullanılır

class LoginServices {
  Future<LoginResponseModel?> login(
      {required String userName, required String password}) async {
    //var toBase64 = utf8.encode(password);
    final base64Str = base64.encode(password.codeUnits);
    try {
      var url = Uri.parse('${Globals.apiBaseUrl}token'); // bu bizim url'imiz uri parse ile url'e çevirdik. içindeki global bi url tanımladık sonrada /token ekledik.
      var result = await http.post(url, //post işlemi yaptık url'e gittik ve body'e username ve password gönderdik. header'a da content type ekledik. 
      //header ve content type olmazsa 415 hatası alırız. 415 hatası unsupported media type hatasıdır. yani desteklenmeyen medya tipi hatasıdır.
      // yani content type'ı belirtmemiz gerekir. content type'ı belirtmezsek varsayılan olarak application/x-www-form-urlencoded olarak gelir.
      // bizim gönderdiğimiz ise application/json'dır. bu yüzden content type'ı belirtmemiz gerekir.
      // body'e gönderdiğimiz verileri json'a çevirmemiz gerekir. bunun için jsonEncode kullandık. 
          body: jsonEncode({"Username": userName, "Password": base64Str}), //jsonEncode ile body'e gönderdiğimiz verileri json'a çevirdik.
          headers: {"Content-Type": "application/json"});
      if (result.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(result.body)); //jsonDecode ile result.body'i json'a çevirdik. sonra da fromJson ile LoginResponseModel'e çevirdik.
        // fromeJson ile LoginResponseModel'e çevirdikten sonra LoginResponseModel'in içindeki data'yı döndürdük. 
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
