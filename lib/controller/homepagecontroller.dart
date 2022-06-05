import 'dart:developer';
import 'package:get/get.dart';
import 'package:loginapp/models/freinds.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

import 'datasavingcontroller.dart';

class HommepageController extends GetxController {
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    getAllfriends();
  }

  List<FriendsModel> allFriends = <FriendsModel>[];
  getAllfriends() async {
    loading = true;
    update();
    DatasavingController datasavingController = DatasavingController();
    ProfileModel? profile = await datasavingController.readProfile();
    var response = await RemoteServices.getMyFriends(profile!.id.toString());
    log(response);
    allFriends = friendsModelFromJson(response);
    loading = false;
    update();
  }
}
