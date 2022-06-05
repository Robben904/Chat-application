import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class SignupController extends GetxController {
  bool loading = false;

  signup(ProfileModel model, BuildContext context) async {
    loading = true;
    update();
    var response = await RemoteServices.signup(model);
    String status = json.decode(response)["status"];
    if (status == "Account created Successfully.") {
      Navigator.pop(context);
    } else {}
    Fluttertoast.showToast(msg: status);
    loading = false;
    update();
  }
}
