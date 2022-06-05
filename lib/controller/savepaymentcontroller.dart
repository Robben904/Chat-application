import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loginapp/utils/remoteservices.dart';

import '../models/paymentmodel.dart';

class SavePaymentController extends GetxController {
  bool loading = false;

  savepayment(PaymentModel model, BuildContext context) async {
    loading = true;

    update();
    var response = await RemoteServices.savepayment(model);
    String status = json.decode(response)["Status"];
    if (status == "Payment successfully") {
      Navigator.pop(context);
    } else {}
    Fluttertoast.showToast(msg: status);
    loading = false;
    update();
  }
}
