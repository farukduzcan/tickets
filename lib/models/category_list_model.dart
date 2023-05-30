class CategoryListModel {
  CategoryListModel({
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

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(
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
    required this.email,
    required this.name,
    required this.users,
    required this.emailHost,
    required this.emailPort,
    required this.emaiUserName,
    required this.emailPassword,
    required this.emailSsl,
  });

  final int? id;
  final String? email;
  final String? name;
  final List<dynamic> users;
  final String? emailHost;
  final int? emailPort;
  final String? emaiUserName;
  final String? emailPassword;
  final bool? emailSsl;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      users: json["users"] == null
          ? []
          : List<dynamic>.from(json["users"]!.map((x) => x)),
      emailHost: json["emailHost"],
      emailPort: json["emailPort"],
      emaiUserName: json["emaiUserName"],
      emailPassword: json["emailPassword"],
      emailSsl: json["emailSsl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "users": users.map((x) => x).toList(),
        "emailHost": emailHost,
        "emailPort": emailPort,
        "emaiUserName": emaiUserName,
        "emailPassword": emailPassword,
        "emailSsl": emailSsl,
      };
}
