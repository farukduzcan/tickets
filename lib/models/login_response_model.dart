class LoginResponseModel {
  UserToken? data;
  dynamic errors;
  int result;

  LoginResponseModel({
    required this.data,
    this.errors,
    required this.result,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        data: json["data"] == null
            ? null
            : UserToken.fromJson(json[
                "data"]), //data null değilse UserToken.fromJson ile json'ı UserToken'a çevirdik. null ise null döndürdük.
        errors: json["errors"],
        result: json["result"],
      );
}

class UserToken {
  //UserToken modeli oluşturduk. bu modelde token ve expires var.
  String token;
  DateTime expires;

  UserToken({
    required this.token,
    required this.expires,
  });

  factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
        //UserToken.fromJson ile json'ı UserToken'a çevirdik.
        token: json["token"], //  token ve expires'ı json'dan aldık.
        expires: DateTime.parse(json["expires"]),
      );
}
