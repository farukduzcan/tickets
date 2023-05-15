class TicketListModel {
  TicketListModel({
    required this.datas,
    required this.errors,
    required this.result,
    required this.totalItemsCount,
    required this.totalPageCount,
    required this.currentPageIndex,
    required this.currentPageSize,
  });

  final List<Data> datas;
  final dynamic errors;
  final int? result;
  final int? totalItemsCount;
  final int? totalPageCount;
  final int? currentPageIndex;
  final int? currentPageSize;

  factory TicketListModel.fromJson(Map<String, dynamic> json) {
    return TicketListModel(
      datas: json["datas"] == null
          ? []
          : List<Data>.from(json["datas"]!.map((x) => Data.fromJson(x))),
      errors: json["errors"],
      result: json["result"],
      totalItemsCount: json["totalItemsCount"],
      totalPageCount: json["totalPageCount"],
      currentPageIndex: json["currentPageIndex"],
      currentPageSize: json["currentPageSize"],
    );
  }

  Map<String, dynamic> toJson() => {
        "datas": datas.map((x) => x.toJson()).toList(),
        "errors": errors,
        "result": result,
        "totalItemsCount": totalItemsCount,
        "totalPageCount": totalPageCount,
        "currentPageIndex": currentPageIndex,
        "currentPageSize": currentPageSize,
      };
}

class Data {
  Data({
    required this.id,
    required this.createUserName,
    required this.categoryId,
    required this.categoryName,
    required this.subject,
    required this.body,
    required this.ticketStatus,
    required this.files,
  });

  final int? id;
  final String? createUserName;
  final int? categoryId;
  final String? categoryName;
  final String? subject;
  final String? body;
  final String? ticketStatus;
  final List<dynamic> files;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      createUserName: json["createUserName"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      subject: json["subject"],
      body: json["body"],
      ticketStatus: json["ticketStatus"],
      files: json["files"] == null
          ? []
          : List<dynamic>.from(json["files"]!.map((x) => x)),
    );
  }

  get title => null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "createUserName": createUserName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "subject": subject,
        "body": body,
        "ticketStatus": ticketStatus,
        "files": files.map((x) => x).toList(),
      };
}
