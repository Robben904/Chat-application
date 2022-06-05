// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel singlelocationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String singlelocationModelToJson(LocationModel data) =>
    json.encode(data.toJson());

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  LocationModel({
    required this.id,
    required this.userid,
    required this.latitude,
    required this.longitude,
    required this.updatedDate,
  });

  int id;
  int userid;
  String latitude;
  String longitude;
  DateTime updatedDate;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        userid: json["userid"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        updatedDate: DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "latitude": latitude,
        "longitude": longitude,
        "updated_date":
            "${updatedDate.year.toString().padLeft(4, '0')}-${updatedDate.month.toString().padLeft(2, '0')}-${updatedDate.day.toString().padLeft(2, '0')}",
      };
}
