// To parse required this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

List<ProfileModel> multipleprofileModelFromJson(String str) =>
    List<ProfileModel>.from(
        json.decode(str).map((x) => ProfileModel.fromJson(x)));

String multipleprofileModelToJson(List<ProfileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.date,
    required this.username,
    required this.email,
    required this.phone,
    required this.bio,
    required this.notificationid,
    required this.dateofbirth,
    required this.profileimage,
    required this.gender,
    required this.chats,
    required this.password,
    required this.address,
  });

  int id;
  DateTime date;
  String username;
  String email;
  String phone;
  String bio;
  String notificationid;
  DateTime dateofbirth;
  String profileimage;
  String gender;
  String chats;
  String password;
  String address;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        bio: json["bio"] ?? "",
        notificationid: json["notificationid"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        profileimage: json["profileimage"],
        gender: json["gender"] ?? "",
        chats: json["chats"] ?? "",
        password: json["password"],
        address: json["address"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "username": username,
        "email": email,
        "phone": phone,
        "bio": bio,
        "notificationid": notificationid,
        "dateofbirth":
            "${dateofbirth.year.toString().padLeft(4, '0')}-${dateofbirth.month.toString().padLeft(2, '0')}-${dateofbirth.day.toString().padLeft(2, '0')}",
        "profileimage": profileimage,
        "gender": gender,
        "chats": chats,
        "password": password,
        "address": address,
      };
}
