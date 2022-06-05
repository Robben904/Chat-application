// To parse this JSON data, do
//
//     final friendsTableModel = friendsTableModelFromJson(jsonString);

import 'dart:convert';

List<FriendsTableModel> friendsTableModelFromJson(String str) =>
    List<FriendsTableModel>.from(
        json.decode(str).map((x) => FriendsTableModel.fromJson(x)));

String friendsTableModelToJson(List<FriendsTableModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FriendsTableModel {
  FriendsTableModel({
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

  factory FriendsTableModel.fromJson(Map<String, dynamic> json) =>
      FriendsTableModel(
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
