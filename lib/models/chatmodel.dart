// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel singleChatModelFromJson(String str) =>
    ChatModel.fromJson(json.decode(str));

String singleChatModelToJson(ChatModel data) => json.encode(data.toJson());

List<ChatModel> chatModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  ChatModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.file,
    required this.chatstime,
  });

  int id;
  String sender;
  String receiver;
  String message;
  String file;
  DateTime chatstime;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        sender: json["sender"],
        receiver: json["receiver"],
        message: json["message"],
        file: json["file"],
        chatstime: DateTime.parse(json["chatstime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "receiver": receiver,
        "message": message,
        "file": file,
        "chatstime": chatstime.toIso8601String(),
      };
}
