class TicketActionCreateModel {
  TicketActionCreateModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final dynamic data;
  final dynamic errors;
  final int? result;

  factory TicketActionCreateModel.fromJson(Map<String, dynamic> json) {
    return TicketActionCreateModel(
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
