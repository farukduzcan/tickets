class GetTicketModel {
  GetTicketModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final Data? data;
  final dynamic errors;
  final int? result;

  factory GetTicketModel.fromJson(Map<String, dynamic> json) {
    return GetTicketModel(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
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

class Data {
  Data({
    required this.id,
    required this.createdBy,
    required this.createUserName,
    required this.customerId,
    required this.customerName,
    required this.categoryId,
    required this.categoryName,
    required this.subject,
    required this.body,
    required this.ticketStatus,
    required this.files,
  });

  final int? id;
  final int? createdBy;
  final String? createUserName;
  final int? customerId;
  final String? customerName;
  final int? categoryId;
  final String? categoryName;
  final String? subject;
  final String? body;
  final String? ticketStatus;
  final List<FileElement> files;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      createdBy: json["createdBy"],
      createUserName: json["createUserName"],
      customerId: json["customerId"],
      customerName: json["customerName"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      subject: json["subject"],
      body: json["body"],
      ticketStatus: json["ticketStatus"],
      files: json["files"] == null
          ? []
          : List<FileElement>.from(
              json["files"]!.map((x) => FileElement.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdBy": createdBy,
        "createUserName": createUserName,
        "customerId": customerId,
        "customerName": customerName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "subject": subject,
        "body": body,
        "ticketStatus": ticketStatus,
        "files": files.map((x) => x.toJson()).toList(),
      };
}

class FileElement {
  FileElement({
    required this.id,
    required this.fileName,
    required this.path,
    required this.ext,
  });

  final int? id;
  final String? fileName;
  final String? path;
  final String? ext;

  factory FileElement.fromJson(Map<String, dynamic> json) {
    return FileElement(
      id: json["id"],
      fileName: json["fileName"],
      path: json["path"],
      ext: json["ext"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fileName": fileName,
        "path": path,
        "ext": ext,
      };
}
