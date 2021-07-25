// To parse this JSON data, do
//
//     final deviceRequest = deviceRequestFromJson(jsonString);

import 'dart:convert';

DeviceRequest deviceRequestFromJson(String str) => DeviceRequest.fromJson(json.decode(str));

String deviceRequestToJson(DeviceRequest data) => json.encode(data.toJson());

class DeviceRequest {
  DeviceRequest({
    this.id,
    this.name,
    this.icon,
    this.functions,
  });

  int id;
  String name;
  String icon;
  List<Func> functions;

  factory DeviceRequest.fromJson(Map<String, dynamic> json) => DeviceRequest(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    functions: List<Func>.from(json["functions"].map((x) => Func.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "functions": List<dynamic>.from(functions.map((x) => x.toJson())),
  };
}

class Func {
  Func({
    this.id,
    this.deviceId,
    this.functionCode,
    this.functionName,
  });

  int id;
  int deviceId;
  String functionCode;
  String functionName;

  factory Func.fromJson(Map<String, dynamic> json) => Func(
    id: json["id"],
    deviceId: json["deviceId"],
    functionCode: json["functionCode"],
    functionName: json["functionName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deviceId": deviceId,
    "functionCode": functionCode,
    "functionName": functionName,
  };
}
