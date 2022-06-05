import 'dart:developer';

import 'package:get/get.dart';
import 'package:loginapp/models/chatmodel.dart';

import '../utils/remoteservices.dart';

class ReadChatController extends GetxController {
  ReadChatController({required this.sender, required this.receiver});
  bool loading = true;
  List<ChatModel> chats = <ChatModel>[];
  final int sender;
  final int receiver;

  readChat() async {
    var response = await RemoteServices.readChat(sender, receiver);
    chats = chatModelFromJson(response);
    log('reading');
    update();
  }
}
