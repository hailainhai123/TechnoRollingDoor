// To parse this JSON data, do
//
//     final doorResponse = doorResponseFromJson(jsonString);

import 'dart:convert';

DoorResponse doorResponseFromJson(String str) => DoorResponse.fromJson(json.decode(str));

String doorResponseToJson(DoorResponse data) => json.encode(data.toJson());

class DoorResponse {
  DoorResponse({
    this.errorCode,
    this.message,
    this.result,
  });

  String errorCode;
  List<Message> message;
  String result;

  factory DoorResponse.fromJson(Map<String, dynamic> json) => DoorResponse(
    errorCode: json["errorCode"],
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "errorCode": errorCode,
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
    "result": result,
  };
}

class Message {
  Message({
    this.id,
    this.matb,
    this.vitri,
    this.status,
    this.time,
    this.ngayupdate,
  });

  String id;
  String matb;
  String vitri;
  String status;
  String time;
  String ngayupdate;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["_id"],
    matb: json["matb"],
    vitri: json["vitri"],
    status: json["status"],
    time: json["time"],
    ngayupdate: json["ngayupdate"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "matb": matb,
    "vitri": vitri,
    "status": status,
    "time": time,
    "ngayupdate": ngayupdate,
  };
}
