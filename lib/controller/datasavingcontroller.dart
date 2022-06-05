import 'dart:developer';

import 'package:get/get.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatasavingController extends GetxController {
  late SharedPreferences preferences;

  saveProfile(ProfileModel model) async {
    preferences = await SharedPreferences.getInstance();
    String data = profileModelToJson(model);
    preferences.setString('profile', data);
    log("Data Saved");
  }

  Future<ProfileModel?> readProfile() async {
    preferences = await SharedPreferences.getInstance();
    String data = preferences.getString('profile') ?? "";
    if (data == "") {
      return null;
    } else {
      return profileModelFromJson(data);
    }
  }

  logout() async {
    preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
