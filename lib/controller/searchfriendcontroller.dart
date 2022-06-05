import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class SearchfriendController extends GetxController {
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    readProfile();
  }

  ProfileModel? profile;

  readProfile() async {
    DatasavingController datasavingController = DatasavingController();
    profile = await datasavingController.readProfile();
    update();
  }

  List<ProfileModel> allFriends = <ProfileModel>[];
  searchFriends(String query) async {
    var response = await RemoteServices.searchfriends(query);
    log(response);
    allFriends = multipleprofileModelFromJson(response);
    update();
  }

  sendFriendRequest(String user2id) async {
    var response = await RemoteServices.sendFriendRequest(
      profile!.id.toString(),
      user2id,
      DateTime.now().toString(),
    );
    Map<String, dynamic> data = json.decode(response);
    Fluttertoast.showToast(msg: data['status']);
  }
}
