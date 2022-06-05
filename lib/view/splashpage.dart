import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/locationmodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  navigateToNextPage() {
    Future.delayed(Duration(seconds: 3)).whenComplete(
      () async {
        DatasavingController dsc = DatasavingController();
        ProfileModel? model = await dsc.readProfile();
        if (model == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'login',
            (route) => false,
          );
        } else {
          RemoteServices.updateNotificationID();
          askForLocation();

          Navigator.pushNamedAndRemoveUntil(
            context,
            'homepage',
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    navigateToNextPage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('icon');

        final MacOSInitializationSettings initializationSettingsMacOS =
            MacOSInitializationSettings(
                requestAlertPermission: false,
                requestBadgePermission: false,
                requestSoundPermission: false);
        final InitializationSettings initializationSettings =
            InitializationSettings(
                android: initializationSettingsAndroid,
                macOS: initializationSettingsMacOS);
        await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        );
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('messagechannel', 'Message Channel',
                channelDescription: 'Message',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker');
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            platformChannelSpecifics,
            payload: 'item x');
      }
    });
  }

  askForLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    DatasavingController dsc = DatasavingController();
    ProfileModel? model = await dsc.readProfile();
    RemoteServices.uploadLocation(
      LocationModel(
        id: 0,
        userid: model!.id,
        latitude: _locationData.latitude.toString(),
        longitude: _locationData.longitude.toString(),
        updatedDate: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
