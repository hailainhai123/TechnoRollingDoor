// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    this.statusCode,
    this.success,
    this.errors,
    this.message,
  });

  int statusCode;
  bool success;
  List<Error> errors;
  String message;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    statusCode: json["statusCode"],
    success: json["success"],
    errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
    "message": message,
  };
}

class Error {
  Error({
    this.key,
    this.value,
  });

  String key;
  String value;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
