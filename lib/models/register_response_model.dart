class RegisterResponseModel {
  RegisterResponseModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final String? data;
  final dynamic errors;
  final int? result;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      data: json["data"],
      errors: json["errors"],
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        "errors": errors,
        "result": result,
      };
}
