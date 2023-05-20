import 'package:tickets/models/fogetpass_mail_model.dart';

class DeleteTicketModel {
  DeleteTicketModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final dynamic data;
  final List<ApiError> errors;
  final int? result;

  factory DeleteTicketModel.fromJson(Map<String, dynamic> json) {
    return DeleteTicketModel(
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
