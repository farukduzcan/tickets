class ManageInfoModel {
  ManageInfoModel({
    required this.data,
    required this.errors,
    required this.result,
  });

  final Data? data;
  final dynamic errors;
  final int? result;

  factory ManageInfoModel.fromJson(Map<String, dynamic> json) {
    return ManageInfoModel(
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
    required this.name,
    required this.address1,
    required this.address2,
    required this.postalCode,
    required this.townId,
    required this.townName,
    required this.cityId,
    required this.cityName,
    required this.countryId,
    required this.countryName,
    required this.email,
    required this.web,
    required this.phone,
    required this.fax,
    required this.contactName,
    required this.logo,
    required this.subDomain,
    required this.emailInviteBody,
    required this.emailInviteSubject,
  });

  final int? id;
  final String? name;
  final dynamic address1;
  final dynamic address2;
  final dynamic postalCode;
  final dynamic townId;
  final dynamic townName;
  final dynamic cityId;
  final dynamic cityName;
  final dynamic countryId;
  final dynamic countryName;
  final dynamic email;
  final dynamic web;
  final dynamic phone;
  final dynamic fax;
  final dynamic contactName;
  final dynamic logo;
  final dynamic subDomain;
  final dynamic emailInviteBody;
  final dynamic emailInviteSubject;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      name: json["name"],
      address1: json["address1"],
      address2: json["address2"],
      postalCode: json["postalCode"],
      townId: json["townId"],
      townName: json["townName"],
      cityId: json["cityId"],
      cityName: json["cityName"],
      countryId: json["countryId"],
      countryName: json["countryName"],
      email: json["email"],
      web: json["web"],
      phone: json["phone"],
      fax: json["fax"],
      contactName: json["contactName"],
      logo: json["logo"],
      subDomain: json["subDomain"],
      emailInviteBody: json["emailInviteBody"],
      emailInviteSubject: json["emailInviteSubject"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address1": address1,
        "address2": address2,
        "postalCode": postalCode,
        "townId": townId,
        "townName": townName,
        "cityId": cityId,
        "cityName": cityName,
        "countryId": countryId,
        "countryName": countryName,
        "email": email,
        "web": web,
        "phone": phone,
        "fax": fax,
        "contactName": contactName,
        "logo": logo,
        "subDomain": subDomain,
        "emailInviteBody": emailInviteBody,
        "emailInviteSubject": emailInviteSubject,
      };
}
