// To parse this JSON data, do
//
//     final loginPostResponse = loginPostResponseFromJson(jsonString);

import 'dart:convert';

LoginPostResponse loginPostResponseFromJson(String str) => LoginPostResponse.fromJson(json.decode(str));

String loginPostResponseToJson(LoginPostResponse data) => json.encode(data.toJson());

class LoginPostResponse {
  LoginPostResponse({
    this.phoneNumber,
    this.password,
    this.isRemember,
  });

  String phoneNumber;
  String password;
  bool isRemember;

  factory LoginPostResponse.fromJson(Map<String, dynamic> json) => LoginPostResponse(
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    isRemember: json["isRemember"],
  );

  Map<String, dynamic> toJson() => {
    "phoneNumber": phoneNumber,
    "password": password,
    "isRemember": isRemember,
  };
}
