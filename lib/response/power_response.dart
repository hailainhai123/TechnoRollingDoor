// To parse this JSON data, do
//
//     final powerResponse = powerResponseFromJson(jsonString);

import 'dart:convert';

PowerResponse powerResponseFromJson(String str) => PowerResponse.fromJson(json.decode(str));

String powerResponseToJson(PowerResponse data) => json.encode(data.toJson());

class PowerResponse {
  PowerResponse({
    this.power,
    this.status,
  });

  String power;
  String status;

  factory PowerResponse.fromJson(Map<String, dynamic> json) => PowerResponse(
    power: json["power"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "power": power,
    "status": status,
  };
}