import 'fogetpass_mail_model.dart';

class RegisterResponseModel {
  static String? confirmationCode;
  RegisterResponseModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final String? data;
  final List<ApiError> errors;
  final int? result;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      data: json["data"],
      errors: json["errors"] == null
          ? []
          : List<ApiError>.from(
              json["errors"]!.map((x) => ApiError.fromJson(x))),
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        "errors": errors.map((x) => x.toJson()).toList(),
        "result": result,
      };
}
