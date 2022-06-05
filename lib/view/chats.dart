import 'dart:developer';
import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/controller/readchatcontroller.dart';
import 'package:loginapp/models/chatmodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';
import 'package:loginapp/view/filepreview.dart';
import 'package:loginapp/view/filepreviewurl.dart';
import 'package:loginapp/view/videoplayerscreenurl.dart';
import 'package:loginapp/view/viewprofile.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {Key? key,
      required this.myId,
      required this.friendId,
      required this.friendProfileModel,
      required this.myProfile})
      : super(key: key);
  final int myId;
  final int friendId;
  final ProfileModel friendProfileModel;
  final ProfileModel myProfile;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DatasavingController dsc = DatasavingController();
  TextEditingController messageController = TextEditingController();
  late ReadChatController readChatController;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    readChatController =
        ReadChatController(sender: widget.myId, receiver: widget.friendId);
    loadChatData();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Message received");
      loadChatData();
      if (message.notification != null) {}
    });
  }

  loadChatData() async {
    await readChatController.readChat();
    scrollController.jumpTo(scrollController.position.maxScrollExtent + 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfile(
                      profile: widget.friendProfileModel,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(RemoteServices.initialUrl +
                    "/profileimages/" +
                    widget.friendProfileModel.profileimage),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(widget.friendProfileModel.username.toString())
            //              Text(widget.myId.toString() + "|" + widget.friendId.toString())
          ],
        ),
      ),
      body: GetBuilder<ReadChatController>(
          init: readChatController,
          builder: (controller) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.chats.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          BubbleSpecialThree(
                            text: controller.chats[index].message,
                            color: Color(0xFF1B97F3),
                            tail: true,
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                            isSender: controller.chats[index].sender ==
                                widget.myId.toString(),
                          ),
                          Row(
                            mainAxisAlignment: controller.chats[index].sender ==
                                    widget.myId.toString()
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              controller.chats[index].file == ""
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        if (controller.chats[index].file
                                            .isVideoFileName) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerScreenUrl(
                                                file:
                                                    RemoteServices.initialUrl +
                                                        "/chats/files/" +
                                                        controller
                                                            .chats[index].file,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: SizedBox(
                                            height: 120,
                                            width: 120,
                                            child: FilePreviewUrl(
                                              file:
                                                  controller.chats[index].file,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              // print(value);
                              if (value == "photos") {
                                final ImagePicker _picker = ImagePicker();
                                // Pick an image
                                // final XFile? image = await _picker.pickImage(
                                //     source: ImageSource.gallery);
                                // Capture a photo
                                final XFile? photo = await _picker.pickImage(
                                    source: ImageSource.camera);
                                File file = File(photo!.path);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilePreview(
                                      file: file,
                                      sender: widget.myId,
                                      receiver: widget.friendId,
                                      friendProfile: widget.friendProfileModel,
                                      myProfile: widget.myProfile,
                                    ),
                                  ),
                                );
                              }
                              if (value == "video") {
                                final ImagePicker _picker = ImagePicker();
                                // Pick an image
                                // final XFile? image = await _picker.pickImage(
                                //     source: ImageSource.gallery);
                                // Capture a photo
                                final XFile? video = await _picker.pickVideo(
                                    source: ImageSource.camera);
                                File file = File(video!.path);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilePreview(
                                      file: file,
                                      sender: widget.myId,
                                      receiver: widget.friendId,
                                      friendProfile: widget.friendProfileModel,
                                      myProfile: widget.myProfile,
                                    ),
                                  ),
                                );
                              }

                              if (value == "file") {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FilePreview(
                                        file: file,
                                        sender: widget.myId,
                                        receiver: widget.friendId,
                                        friendProfile:
                                            widget.friendProfileModel,
                                        myProfile: widget.myProfile,
                                      ),
                                    ),
                                  );
                                } else {
                                  // User canceled the picker
                                }
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                // PopupMenuItem(
                                //   child: Text("Photos"),
                                //   value: "photos",
                                // ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            final ImagePicker _picker =
                                                ImagePicker();
                                            // Pick an image
                                            // final XFile? image = await _picker.pickImage(
                                            //     source: ImageSource.gallery);
                                            // Capture a photo
                                            final XFile? photo =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            File file = File(photo!.path);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FilePreview(
                                                  file: file,
                                                  sender: widget.myId,
                                                  receiver: widget.friendId,
                                                  friendProfile:
                                                      widget.friendProfileModel,
                                                  myProfile: widget.myProfile,
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.camera)),
                                      IconButton(
                                          onPressed: () async {
                                            final ImagePicker _picker =
                                                ImagePicker();
                                            // Pick an image
                                            // final XFile? image = await _picker.pickImage(
                                            //     source: ImageSource.gallery);
                                            // Capture a photo
                                            final XFile? photo =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            File file = File(photo!.path);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FilePreview(
                                                  file: file,
                                                  sender: widget.myId,
                                                  receiver: widget.friendId,
                                                  friendProfile:
                                                      widget.friendProfileModel,
                                                  myProfile: widget.myProfile,
                                                ),
                                              ),
                                            );
                                          },
                                          icon:
                                              Icon(Icons.browse_gallery_sharp))
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: Row(children: [
                                    IconButton(
                                        onPressed: () async {
                                          final ImagePicker _picker =
                                              ImagePicker();

                                          final XFile? photo =
                                              await _picker.pickVideo(
                                                  source: ImageSource.camera);
                                          File file = File(photo!.path);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FilePreview(
                                                file: file,
                                                sender: widget.myId,
                                                receiver: widget.friendId,
                                                friendProfile:
                                                    widget.friendProfileModel,
                                                myProfile: widget.myProfile,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.videocam)),
                                    IconButton(
                                        onPressed: () async {
                                          final ImagePicker _picker =
                                              ImagePicker();

                                          final XFile? photo =
                                              await _picker.pickVideo(
                                                  source: ImageSource.gallery);
                                          File file = File(photo!.path);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FilePreview(
                                                file: file,
                                                sender: widget.myId,
                                                receiver: widget.friendId,
                                                friendProfile:
                                                    widget.friendProfileModel,
                                                myProfile: widget.myProfile,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.collections))
                                  ]),
                                ),
                                PopupMenuItem(
                                  child: Text("Doc"),
                                  value: "file",
                                ),
                                // PopupMenuItem(
                                //   child: Text("Starred messages"),
                                //   value: "Starred messages",
                                // ),
                                // PopupMenuItem(
                                //   child: Text("Settings"),
                                //   value: "Settings",
                                // ),
                              ];
                            },
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: messageController,
                            decoration:
                                InputDecoration(hintText: 'Type message'),
                          )),
                          IconButton(
                            onPressed: () async {
                              if (messageController.text.trim() == "") {
                              } else {
                                await RemoteServices.sendChat(
                                  ChatModel(
                                    id: 0,
                                    sender: widget.myId.toString(),
                                    receiver: widget.friendId.toString(),
                                    message: messageController.text,
                                    file: "",
                                    chatstime: DateTime.now(),
                                  ),
                                  null,
                                );
                                messageController.clear();
                                loadChatData();
                                RemoteServices.sendNotification(
                                  title:
                                      "${widget.myProfile.username} sent a message",
                                  body: messageController.text,
                                  type: 'chat',
                                  to: widget.friendProfileModel.notificationid,
                                );
                              }
                            },
                            icon: Icon(Icons.send),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
