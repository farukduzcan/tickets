class LoginResponseModel {
    UserToken? data;
    dynamic errors;
    int result;

    LoginResponseModel({
        required this.data,
        this.errors,
        required this.result,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        data: json["data"] == null ? null : UserToken.fromJson(json["data"]),
        errors: json["errors"],
        result: json["result"],
    );

}

class UserToken {
    String token;
    DateTime expires;

    UserToken({
        required this.token,
        required this.expires,
    });

    factory UserToken.fromJson(Map<String, dynamic> json) => UserToken(
        token: json["token"],
        expires: DateTime.parse(json["expires"]),
    );

}
