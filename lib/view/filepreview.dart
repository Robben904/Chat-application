// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/view/videoplayerscreen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../models/chatmodel.dart';
import '../utils/remoteservices.dart';

class FilePreview extends StatefulWidget {
  FilePreview({
    Key? key,
    required this.file,
    required this.sender,
    required this.receiver,
    this.isSending = true,
    required this.myProfile,
    required this.friendProfile,
  }) : super(key: key);
  File file;
  int sender;
  int receiver;
  bool isSending;
  ProfileModel myProfile;
  ProfileModel friendProfile;
  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select file"),
        actions: [
          IconButton(
            onPressed: () async {
              await RemoteServices.sendChat(
                ChatModel(
                  id: 0,
                  sender: widget.sender.toString(),
                  receiver: widget.receiver.toString(),
                  message: "Sent a file",
                  file: "",
                  chatstime: DateTime.now(),
                ),
                widget.file,
              );
              // messageController.clear();
              // loadChatData();
              RemoteServices.sendNotification(
                title: "${widget.myProfile.username} sent a file",
                body: "You received a file",
                type: 'chat',
                to: widget.friendProfile.notificationid,
              );
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
      ),
      body: getFilePreview(widget.file),
    );
  }

  // /file/foldernam/a.jpg

  Widget getFilePreview(File file) {
    String path = file.path;
    if (path.isImageFileName) {
      return Image.file(file);
    } else if (path.isVideoFileName) {
      return VideoPlayerScreen(file: file);
    } else if (path.isPDFFileName) {
      return SfPdfViewer.file(file);
    } else {
      return SizedBox(
        height: 100,
        width: Get.width,
        child: Row(
          children: [Icon(Icons.file_open_rounded), Text(path.split('/').last)],
        ),
      );
    }
  }
}
