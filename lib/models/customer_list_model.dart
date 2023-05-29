class CustomerListModel {
  CustomerListModel({
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

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    return CustomerListModel(
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
    required this.firstName,
    required this.lastName,
    required this.isActive,
  });

  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final bool? isActive;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      isActive: json["isActive"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "isActive": isActive,
      };
}
