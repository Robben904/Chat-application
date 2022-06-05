// To parse this JSON data, do
//
//     final friendsModel = friendsModelFromJson(jsonString);

import 'dart:convert';

List<FriendsModel> friendsModelFromJson(String str) => List<FriendsModel>.from(
    json.decode(str).map((x) => FriendsModel.fromJson(x)));

String friendsModelToJson(List<FriendsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FriendsModel {
  FriendsModel({
    required this.id,
    required this.useroneid,
    required this.usertwoid,
    required this.date,
    required this.accepted,
  });

  int id;
  int useroneid;
  int usertwoid;
  DateTime date;
  String accepted;

  factory FriendsModel.fromJson(Map<String, dynamic> json) => FriendsModel(
        id: json["id"],
        useroneid: json["useroneid"],
        usertwoid: json["usertwoid"],
        date: DateTime.parse(json["date"]),
        accepted: json["accepted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "useroneid": useroneid,
        "usertwoid": usertwoid,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "accepted": accepted,
      };
}
