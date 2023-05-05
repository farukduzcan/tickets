class ForgetPassMailModel {
  static String? resetPasswordCode;
  ForgetPassMailModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final String? data;
  final List<ApiError> errors;
  final int? result;

  factory ForgetPassMailModel.fromJson(Map<String, dynamic> json) {
    return ForgetPassMailModel(
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

class ApiError {
  ApiError({
    required this.property,
    required this.error,
  });

  final String? property;
  final String? error;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      property: json["property"],
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
        "property": property,
        "error": error,
      };
}
