import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../controller/fetchalluserlocation.dart';

class MapPage extends StatefulWidget {
  MapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition? _myLocation;

  @override
  void initState() {
    super.initState();
    getMyLocation();
  }

  getMyLocation() async {
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
    if (_locationData.latitude == null || _locationData.longitude == null) {
      _myLocation = CameraPosition(
        target: LatLng(28.212856857933172, 83.97545134333001),
        zoom: 14.4746,
      );
    } else {
      _myLocation = CameraPosition(
        target: LatLng(_locationData.latitude!, _locationData.longitude!),
        zoom: 14.4746,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchAllUserlocation>(
        init: FetchAllUserlocation(context: context),
        builder: (controller) {
          return Scaffold(
            body: Container(
              child: _myLocation == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: _myLocation!,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: controller.markers,
                    ),
            ),
          );
        });
  }
}
