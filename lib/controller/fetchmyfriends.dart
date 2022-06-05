import 'dart:developer';

import 'package:get/get.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/friendstablemodel.dart';
import 'package:loginapp/models/friendswithprofilemodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class FetchMyFriendsController extends GetxController {
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    fetchMyFriends();
  }

  ProfileModel? profile;
  List<FriendsWithProfileModel> friends = <FriendsWithProfileModel>[];
  fetchMyFriends() async {
    loading = true;
    update();
    friends.clear();
    DatasavingController datasavingController = DatasavingController();
    List<FriendsTableModel> friendsraw = <FriendsTableModel>[];
    log("Here");
    profile = await datasavingController.readProfile();
    var response = await RemoteServices.getMyFriends(profile!.id.toString());

    friendsraw = friendsTableModelFromJson(response);
    log(response);
    for (var item in friendsraw) {
      var response1 =
          await RemoteServices.getProfileData(item.useroneid.toString());
      var response2 =
          await RemoteServices.getProfileData(item.usertwoid.toString());
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
