// To parse this JSON data, do
//
//     final modelAirconditionalResponse = modelAirconditionalResponseFromJson(jsonString);

import 'dart:convert';

ModelAirconditionalResponse modelAirconditionalResponseFromJson(String str) => ModelAirconditionalResponse.fromJson(json.decode(str));

String modelAirconditionalResponseToJson(ModelAirconditionalResponse data) => json.encode(data.toJson());

class ModelAirconditionalResponse {
  ModelAirconditionalResponse({
    this.errorCode,
    this.message,
    this.id,
    this.result,
  });

  String errorCode;
  String message;
  List<IdModel> id;
  String result;

  factory ModelAirconditionalResponse.fromJson(Map<String, dynamic> json) => ModelAirconditionalResponse(
    errorCode: json["errorCode"],
    message: json["message"],
    id: List<IdModel>.from(json["id"].map((x) => IdModel.fromJson(x))),
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "message": message,
    "id": List<dynamic>.from(id.map((x) => x.toJson())),
    "result": result,
  };
}

class IdModel {
  IdModel({
    this.stt,
    this.mahang,
    this.model,
    this.protocol,
    this.idprotocol,

  });

  String stt;
  String mahang;
  String model;
  String protocol;
  String idprotocol;

  factory IdModel.fromJson(Map<String, dynamic> json) => IdModel(
    stt: json["stt"],
    mahang: json["mahang"],
    model: json["model"],
    protocol: json["protocol"],
    idprotocol: json["idprotocol"],
  );

  Map<String, dynamic> toJson() => {
    "stt": stt,
    "mahang": mahang,
    "model": model,
    "protocol": protocol,
    "idprotocol": idprotocol,
  };
}
