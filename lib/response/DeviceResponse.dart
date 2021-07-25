// To parse this JSON data, do
//
//     final deviceResponse = deviceResponseFromJson(jsonString);

import 'dart:convert';

DeviceResponse deviceResponseFromJson(String str) => DeviceResponse.fromJson(json.decode(str));

String deviceResponseToJson(DeviceResponse data) => json.encode(data.toJson());

class DeviceResponse {
  DeviceResponse({
    this.statusCode,
    this.success,
    this.data,
    this.message,
  });

  int statusCode;
  bool success;
  Data data;
  String message;

  factory DeviceResponse.fromJson(Map<String, dynamic> json) => DeviceResponse(
    statusCode: json["statusCode"],
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.icon,
    this.functions,
  });

  int id;
  String name;
  String icon;
  List<Function> functions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    functions: List<Function>.from(json["functions"].map((x) => Function.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "functions": List<dynamic>.from(functions.map((x) => x.toJson())),
  };
}

class Function {
  Function({
    this.id,
    this.deviceId,
    this.functionCode,
    this.functionName,
  });

  int id;
  int deviceId;
  String functionCode;
  String functionName;

  factory Function.fromJson(Map<String, dynamic> json) => Function(
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
