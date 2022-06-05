import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/chatmodel.dart';
import 'package:loginapp/models/locationmodel.dart';
import 'package:loginapp/models/paymentmodel.dart';
import 'package:loginapp/models/profilemodel.dart';

class RemoteServices {
  // to get ip address run 'ipconfig' in cmd or terminal
  // copy the ipv4 form there
  static String initialUrl = "http://10.20.28.184/myapp";

  // Method for signup (creating account)
  // static Future<String> signup(ProfileModel model) async {
  // String url = initialUrl + '/signup.php';
  // FormData data = FormData.fromMap(
  //   json.decode(
  //     profileModelToJson(model),
  //   ),
  // );
  // var response = await Dio().post(url, data: data);
  // return response.data;
  // }

  // Method for login (requires email and password)
  static Future<String> login(String email, String password) async {
    String notif = await FirebaseMessaging.instance.getToken() ?? "";
    var url = initialUrl +
        '/login.php?email=$email&password=$password&notificationId=$notif';
    log(url);
    var response = await Dio().get(url);
    log(response.data);
    return response.data;
  }

  static Future<void> updateNotificationID() async {
    String notif = await FirebaseMessaging.instance.getToken() ?? "";
    DatasavingController dsc = DatasavingController();
    ProfileModel? profile = await dsc.readProfile();
    var url = initialUrl +
        '/updatenotification.php?notificationid=$notif&id=${profile!.id}';
    await Dio().get(url);
  }

  static Future<String> signup(ProfileModel model) async {
    var url = initialUrl + '/signup.php';
    FormData data = FormData.fromMap(json.decode(profileModelToJson(model)));
    var response = await Dio().post(url, data: data);
    log(response.data);
    return response.data;
  }

  static Future<String> updateProfile(ProfileModel model, File? file) async {
    var url = initialUrl + '/updateprofile/profileupdate.php';
    FormData data = FormData.fromMap(json.decode(profileModelToJson(model)));
    if (file == null) {
    } else {
      data.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(
            file.path,
          ),
        ),
      );
    }
    var response = await Dio().post(url, data: data);
    log(response.data);
    return response.data;
  }

  static Future<String> acceptFriendRequest(String id) async {
    String url = initialUrl + "/friends/acceptrequest.php?id=$id";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<String> sendChat(ChatModel model, File? file) async {
    var url = initialUrl + '/chats/chats.php';
    FormData data = FormData.fromMap(
      json.decode(
        singleChatModelToJson(model),
      ),
    );
    if (file == null) {
    } else {
      data.files.add(
        MapEntry(
          "file",
          await MultipartFile.fromFile(file.path),
        ),
      );
    }
    var response = await Dio().post(url, data: data);
    return response.data;
  }

  static Future<String> readChat(int sender, int receiver) async {
    var url = initialUrl + "/chats/read.php?sender=$sender&receiver=$receiver";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<ChatModel?> readLatestChat(int sender, int receiver) async {
    var url = initialUrl +
        "/chats/readlatestchat.php?sender=$sender&receiver=$receiver";
    var response = await Dio().get(url);
    if (response.data == "false") {
      return null;
    } else {
      ChatModel model = singleChatModelFromJson(response.data);
      return model;
    }
  }

  static Future<String> getAllfriends() async {
    var url = initialUrl + "/friends/read.php";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<String> getalluserloaction() async {
    var url = initialUrl + "/location/read.php";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<String> searchfriends(String username) async {
    var url = initialUrl + "/friends/searchfriend.php?query=$username";
    log(url);
    var response = await Dio().get(url);
    log(response.data);
    return response.data;
  }

  static Future<String> getfriendrequest(String id) async {
    var url = initialUrl + "/friends/fetchmyfriendrequests.php?userid=$id";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<String> getMyFriends(String id) async {
    var url = initialUrl + "/friends/fetchmyfriends.php?userid=$id";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<String> getProfileData(String id) async {
    String url = initialUrl + "/readprofile.php?id=$id";
    var response = await Dio().get(url);
    return response.data;
  }

  static Future<String> savepayment(PaymentModel model) async {
    String url = initialUrl + "/payments/create.php";
    FormData data = FormData.fromMap(
      json.decode(
        singlepaymentModelToJson(model),
      ),
    );
    var response = await Dio().post(url, data: data);
    return response.data;
  }

  static Future<String> sendFriendRequest(
      String user1id, String user2id, String date) async {
    var url = initialUrl + "/friends/sendfriendrequest.php";
    FormData data = FormData.fromMap({
      "useroneid": user1id,
      "usertwoid": user2id,
      "date": date,
    });
    var response = await Dio().post(url, data: data);
    log(response.data);
    return response.data;
  }

  static Future<String> uploadLocation(LocationModel model) async {
    var url = initialUrl + "/location/location.php";
    FormData data = FormData.fromMap(
      json.decode(
        singlelocationModelToJson(model),
      ),
    );
    var response = await Dio().post(url, data: data);
    log(response.data);
    return response.data;
  }

  static void sendNotification(
      {required String title,
      required String body,
      required String type,
      String key = "Talk TO",
      String image = "",
      String to = "/topics/all"}) async {
    String url = ('https://fcm.googleapis.com/fcm/send');
    String jsonBody = json.encode({
      'notification': <String, dynamic>{
        'body': body,
        'title': title,
        'image': image,
      },
      "android": {
        "notification": {
          "image": image,
        }
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'title': title,
        'body': body,
        "image": image,
        "type": type,
        "key": key,
        'channel': 'channelname'
      },
      'to': to == 'all' ? '/topics/all' : to,
      // 'to': await firebaseMessaging.getToken(),
    });
    var response = await Dio().post(
      url,
      data: FormData.fromMap(
        json.decode(jsonBody),
      ),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAE-qd1ds:APA91bEwtb2hSEc4eMNpVK_iBkyUctoeN3SWbfyJHUOSz_ZOpVaO9lyv8SWdAyhVGo0jfIUmwLV2-D0kZiizZAPbbfZObIhXFAHaBKxfa-6WkyTHlLtwNnQ-HTSFdq4Qhjli0EIkJNkP',
        },
      ),
    );

    log(response.data);
  }

  // static Future<String> createnotification(NotificationModel model) async {
  //   String url = '$initialUrl/createnotification.php';
  //   var response = await Dio().post(
  //     url,
  //     data: notificationModelToJson(model),
  //   );
  //   log(response.data);
  //   return response.data;
  // }

  // static Future<String> readnotification(String email) async {
  //   Uri url = Uri.parse('$initialUrl/readnotification.php?user=$email');
  //   var response = await Dio.(url);
  //   return response.body;
  // }
  static Future<String> changePassword(
      String email, String currentPassword, String newPassword) async {
    String url = '$initialUrl/changepassword.php';

    var response = await Dio().post(
      url,
      data: FormData.fromMap({
        "email": email,
        "password": currentPassword,
        "newpassword": newPassword,
      }),
    );
    log(response.data);
    return response.data;
  }

  static Future<String> requestPasswordChange({
    required String email,
  }) async {
    log("<==Changing the password==>");
    String url = '$initialUrl/passwordreset/requestreset.php?email=$email';

    var response = await Dio().get(url);
    log(response.data);
    return response.data;
  }

  static Future<String> submitVerificationCode(
      String code, String email) async {
    log("<==Submitting Verification Code==>");
    String url =
        '$initialUrl/passwordreset/verifyCode.php?email=$email&token=$code';
    var response = await Dio().get(url);
    log(response.data);
    return response.data;
  }

  static Future<String> resetPassword(
      String token, String email, String password) async {
    log("<==Resetting the password==>");
    String url = '$initialUrl/passwordreset/resetpassword.php';

    var response = await Dio().post(
      url,
      data: FormData.fromMap({
        "email": email,
        "token": token,
        "password": password,
      }),
    );
    log(response.data);
    return response.data;
  }
}
