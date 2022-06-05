import 'dart:convert';
import 'dart:developer';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loginapp/controller/datasavingcontroller.dart';
import 'package:loginapp/models/locationreadingmodel.dart';
import 'package:loginapp/models/profilemodel.dart';
import 'package:loginapp/utils/remoteservices.dart';

class FetchAllUserlocation extends GetxController {
  bool loading = false;
  List<LocationReadingModel> allLocations = <LocationReadingModel>[];
  Set<Marker> markers = {};
  final BuildContext context;
  FetchAllUserlocation({required this.context});
  @override
  onInit() {
    super.onInit();
    fetchallusers();
  }

  fetchallusers() async {
    loading = true;

    update();
    log("Fetching");
    var response = await RemoteServices.getalluserloaction();
    log(response);
    allLocations = locationReadingModelFromJson(response);
    for (var item in allLocations) {
      markers.add(
        await generatemarkericon(
            double.parse(item.latitude),
            double.parse(item.longitude),
            item.id,
            RemoteServices.initialUrl + "/profileimages/" + item.profileimage,
            context,
            item),
      );
    }
    log(markers.length.toString());
    loading = false;
    update();
  }

  Future<Marker> generatemarkericon(
    double lat,
    double lon,
    int id,
    String image,
    BuildContext context,
    LocationReadingModel model,
  ) async {
    log(image);
    Marker marker = Marker(
      markerId: MarkerId("$id"),
      infoWindow: InfoWindow(title: model.username),
      position: LatLng(lat, lon),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Stranger",
                style: (TextStyle(fontWeight: FontWeight.bold)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(RemoteServices.initialUrl +
                        "/profileimages/" +
                        model.profileimage),
                    radius: 28,
                  ),
                  Text(model.username),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close", textAlign: TextAlign.left)),
                TextButton(
                  onPressed: () async {
                    DatasavingController dsc = DatasavingController();
                    ProfileModel? profile = await dsc.readProfile();
                    String response = await RemoteServices.sendFriendRequest(
                      profile!.id.toString(),
                      model.userid.toString(),
                      DateTime.now().toString(),
                    );
                    String data = json.decode(response)['status'];
                    Fluttertoast.showToast(msg: data);
                    Navigator.pop(context);
                  },
                  child: Text("Add Friend"),
                ),
              ],
            );
          },
        );
      },
      //icon: await MarkerIcon.downloadResizePictureCircle(
      //  image,
      //  size: 150,
      //  addBorder: true,
      //  borderColor: Colors.white,
      //  borderSize: 15,
      //),
    );
    return marker;
  }
}
