// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.lastName,
    this.password = '',
    required this.loginType,
    required this.contact,
    required this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"] ?? '',
        lastName: json["last_name"],
        loginType: json["login_type"] ?? '',
        contact: json["contact"],
        fcmToken: json["fcm_token"] ?? '',
      );

  String contact;
  String email;
  String id;
  String lastName;
  String loginType;
  String name;
  String password;
  String fcmToken;

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "last_name": lastName,
        "contact": contact.trim(),
        "fcm_token": fcmToken.trim(),
      };
}
