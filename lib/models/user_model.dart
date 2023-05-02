import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserModel {
  static String? userToken;
  UserModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final UserData? data;
  final dynamic errors;
  final int? result;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: json["data"] == null ? null : UserData.fromJson(json["data"]),
      errors: json["errors"],
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "errors": errors,
        "result": result,
      };
}

class UserData {
  UserData({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  final String? email;
  final dynamic firstName;
  final dynamic lastName;
  final int? role;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
      };
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