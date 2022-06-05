// To parse required this JSON data, do
//
//     final locationReadingModel = locationReadingModelFromJson(jsonString);

import 'dart:convert';

List<LocationReadingModel> locationReadingModelFromJson(String str) =>
    List<LocationReadingModel>.from(
        json.decode(str).map((x) => LocationReadingModel.fromJson(x)));

String locationReadingModelToJson(List<LocationReadingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationReadingModel {
  LocationReadingModel({
    required this.id,
    required this.userid,
    required this.latitude,
    required this.longitude,
    required this.updatedDate,
    required this.username,
    required this.profileimage,
    required this.email,
    required this.phone,
    required this.address,
  });

  int id;
  int userid;
  String latitude;
  String longitude;
  DateTime updatedDate;
  String username;
  String profileimage;
  String email;
  String phone;
  String address;

  factory LocationReadingModel.fromJson(Map<String, dynamic> json) =>
      LocationReadingModel(
        id: json["id"],
        userid: json["userid"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        updatedDate: DateTime.parse(json["updated_date"]),
        username: json["username"],
        profileimage: json["profileimage"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "latitude": latitude,
        "longitude": longitude,
        "updated_date":
            "${updatedDate.year.toString().padLeft(4, '0')}-${updatedDate.month.toString().padLeft(2, '0')}-${updatedDate.day.toString().padLeft(2, '0')}",
        "username": username,
        "profileimage": profileimage,
        "email": email,
        "phone": phone,
        "address": address,
      };
}
