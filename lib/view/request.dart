import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginapp/controller/friendrequestcontroller.dart';
import 'package:loginapp/models/friendswithprofilemodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';
import 'package:loginapp/view/viewprofile.dart';

class FriendRequest extends StatelessWidget {
  const FriendRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<Friendrequestcontroller>(
        init: Friendrequestcontroller(),
        builder: (controller) {
          return controller.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.friends.isEmpty
                  ? Center(child: Text("No Requests"))
                  : ListView.builder(
                      itemCount: controller.friends.length,
                      itemBuilder: (context, i) {
                        FriendsWithProfileModel model = controller.friends[i];
                        ProfileModel otherProfile =
                            model.user1.id == controller.profile!.id
                                ? model.user2
                                : model.user1;
                        return Builder(builder: (context) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewProfile(
                                    profile: otherProfile,
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              otherProfile.username,
                            ),
                            subtitle: Text(
                              otherProfile.email,
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                int id = controller.friendsraw[i].id;
                                await RemoteServices.acceptFriendRequest(
                                  id.toString(),
                                );
                                controller.fetchFriendRequest();
                              },
                              icon: Icon(Icons.person_add_alt_1),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  RemoteServices.initialUrl +
                                      "/profileimages/" +
                                      otherProfile.profileimage),
                            ),
                          );
                        });
                      },
                    );
        },
      ),
    );
  }
}
