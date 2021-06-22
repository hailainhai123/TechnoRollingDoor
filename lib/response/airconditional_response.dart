import 'dart:convert';

AirConditionerResponse airConditionerResponseFromJson(String str) => AirConditionerResponse.fromJson(json.decode(str));

String airConditionerResponseToJson(AirConditionerResponse data) => json.encode(data.toJson());

class AirConditionerResponse {
  AirConditionerResponse({
    this.errorCode,
    this.message,
    this.id,
  });

  String errorCode;
  String message;
  List<Id> id;

  factory AirConditionerResponse.fromJson(Map<String, dynamic> json) => AirConditionerResponse(
    errorCode: json["errorCode"],
    message: json["message"],
    id: List<Id>.from(json["id"].map((x) => Id.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "message": message,
    "id": List<dynamic>.from(id.map((x) => x.toJson())),
  };
}

class Id {
  Id({
    this.mahang,
    this.hang,
  });

  String mahang;
  String hang;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    mahang: json["mahang"],
    hang: json["Hang"],
  );

  Map<String, dynamic> toJson() => {
    "mahang": mahang,
    "Hang": hang,
  };
}