import 'dart:developer';

import 'package:get/get.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/friendstablemodel.dart';
import 'package:loginapp/models/friendswithprofilemodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class Friendrequestcontroller extends GetxController {
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    fetchFriendRequest();
  }

  ProfileModel? profile;
  List<FriendsTableModel> friendsraw = <FriendsTableModel>[];
  List<FriendsWithProfileModel> friends = <FriendsWithProfileModel>[];
  fetchFriendRequest() async {
    loading = true;
    update();
    friendsraw.clear();
    friends.clear();
    DatasavingController datasavingController = DatasavingController();
    log("Here");
    profile = await datasavingController.readProfile();
    var response = await RemoteServices.getfriendrequest(
      profile!.id.toString(),
    );

    friendsraw = friendsTableModelFromJson(response);
    for (var item in friendsraw) {
      var response1 =
          await RemoteServices.getProfileData(item.useroneid.toString());
      var response2 =
          await RemoteServices.getProfileData(item.usertwoid.toString());

      log(response1);
      log(response2);

      friends.add(
        FriendsWithProfileModel(
          user1: profileModelFromJson(response1),
          user2: profileModelFromJson(response2),
        ),
      );
      update();
    }
    loading = false;
    update();
  }
}
