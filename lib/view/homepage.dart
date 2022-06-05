import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:loginapp/app_theme.dart';

import 'package:get/get.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/controller/fetchmyfriends.dart';
import 'package:loginapp/models/chatmodel.dart';
import 'package:loginapp/models/friendswithprofilemodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';
import 'package:loginapp/view/chats.dart';
import 'package:loginapp/view/mappage.dart';
import 'package:loginapp/view/request.dart';
import 'package:loginapp/widgets/my_tab_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _MyHomepage createState() => _MyHomepage();
}

class _MyHomepage extends State<Homepage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        fetchMyFriendsController.fetchMyFriends();
      }
    });
  }

  FetchMyFriendsController fetchMyFriendsController =
      Get.put(FetchMyFriendsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.kPrimaryColor,
        leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, 'settings');
            }),
        title: Text(
          "Talk To?",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "snap",
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_search),
            onPressed: () {
              Navigator.pushNamed(context, 'searchfriend');
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: MyTheme.kPrimaryColor,
      body: Column(
        children: [
          MyTabBar(tabController: tabController),
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                'Recent Chats',
                                style: MyTheme.heading2,
                              ),
                              Spacer(),
                              Icon(
                                Icons.search,
                                color: MyTheme.kPrimaryColor,
                              )
                            ],
                          ),
                        ),
                        GetBuilder<FetchMyFriendsController>(
                          init: fetchMyFriendsController,
                          builder: (controller) {
                            return Expanded(
                              child: RefreshIndicator(
                                onRefresh: () {
                                  return controller.fetchMyFriends();
                                },
                                child: ListView.builder(
                                  itemCount: controller.friends.length,
                                  itemBuilder: (context, index) {
                                    FriendsWithProfileModel model =
                                        controller.friends[index];
                                    ProfileModel otherProfile =
                                        model.user1.id == controller.profile!.id
                                            ? model.user2
                                            : model.user1;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          RemoteServices.initialUrl +
                                              "/profileimages/" +
                                              otherProfile.profileimage,
                                        ),
                                      ),
                                      title: Text(otherProfile.username),
                                      subtitle: FutureBuilder<ChatModel?>(
                                          future: RemoteServices.readLatestChat(
                                            model.user2.id,
                                            model.user1.id,
                                          ),
                                          builder: (context, snapshot) {
                                            return snapshot.data == null
                                                ? Text("")
                                                : Text(snapshot.data!.message);
                                          }),
                                      onTap: () async {
                                        DatasavingController dsc =
                                            DatasavingController();
                                        ProfileModel? profile =
                                            await dsc.readProfile();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                              myId: profile!.id,
                                              friendId: otherProfile.id,
                                              friendProfileModel: otherProfile,
                                              myProfile: profile,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  MapPage(),
                  FriendRequest(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
