import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class LoginController extends GetxController {
  bool loading = false;

  login(String email, String password, BuildContext context) async {
    loading = true;
    update();
    var response = await RemoteServices.login(email, password);
    Map<String, dynamic> data = json.decode(response);
    if (data.containsKey("status")) {
      Fluttertoast.showToast(msg: data['status']);
    } else {
      ProfileModel profile = profileModelFromJson(response);
      log("Else");
      DatasavingController datasavingController = DatasavingController();
      datasavingController.saveProfile(profile);
      Fluttertoast.showToast(msg: "Login Success");
      Navigator.pushNamedAndRemoveUntil(context, 'homepage', (route) => false);
    }
    loading = false;
    update();
  }

  silentLogin(String email, String password, BuildContext context) async {
    var response = await RemoteServices.login(email, password);
    Map<String, dynamic> data = json.decode(response);
    if (data.containsKey("status")) {
    } else {
      ProfileModel profile = profileModelFromJson(response);
      DatasavingController datasavingController = DatasavingController();
      datasavingController.saveProfile(profile);
      Navigator.pushNamedAndRemoveUntil(context, 'homepage', (route) => false);
    }
    loading = false;
    update();
  }
}
