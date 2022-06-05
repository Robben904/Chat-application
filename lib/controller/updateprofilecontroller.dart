import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loginapp/controller/logincontroller.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class UpdateProfileCotroller extends GetxController {
  bool loading = false;

  updateprofile(ProfileModel model, BuildContext context, File? file) async {
    loading = true;
    update();
    var response = await RemoteServices.updateProfile(model, file);
    log(response);
    String status = json.decode(response)["Status"];
    if (status == "Data Uploaded") {
      LoginController loginController = LoginController();
      await loginController.silentLogin(model.email, model.password, context);
      Fluttertoast.showToast(msg: "Profile Updated");
    } else {
      Fluttertoast.showToast(msg: status);
      loading = false;
      update();
    }
  }
}
