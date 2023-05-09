import 'package:tickets/models/fogetpass_mail_model.dart';

class CategorySelectList {
  CategorySelectList({
    required this.data,
    required this.errors,
    required this.result,
  });

  final List<Datum> data;
  final List<ApiError> errors;
  final int? result;

  factory CategorySelectList.fromJson(Map<String, dynamic> json) {
    return CategorySelectList(
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      errors: json["errors"] == null
          ? []
          : List<ApiError>.from(
              json["errors"]!.map((x) => ApiError.fromJson(x))),
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
        "errors": errors,
        "result": result,
      };
}

class Datum {
  Datum({
    required this.label,
    required this.value,
    required this.description,
  });

  final String? label;
  final int? value;
  final dynamic description;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      label: json["label"],
      value: json["value"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "description": description,
      };
}
