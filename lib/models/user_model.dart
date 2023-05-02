import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserModel {
  UserModel._();
  static String? userToken;
}

FlutterSecureStorage storage = const FlutterSecureStorage();

Future<void> setToken(String token) async {
  await storage.write(key: "token", value: token);
}

Future<String?> getToken() async {
  var result = await storage.read(key: "token");
  if (result == null) {
    log("User token is null");
  } else {
    log("User token is not null");
  }

  return result;
}

Future<void> deleteToken() async {
  await storage.delete(key: "token");
}
