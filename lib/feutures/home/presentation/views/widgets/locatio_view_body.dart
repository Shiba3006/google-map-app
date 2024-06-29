import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocatioViewBody extends StatefulWidget {
  const LocatioViewBody({super.key});

  @override
  State<LocatioViewBody> createState() => _LocatioViewBodyState();
}

class _LocatioViewBodyState extends State<LocatioViewBody> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  late Location location;
  @override
  void initState() {
    super.initState();
    location = Location();
    initCameraPosition();
    checkRequestUpdateLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) => mapController = controller,
    );
  }

  void initCameraPosition() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 12,
    );
  }

  Future<void> checkAndRequestLocationService() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        // TODO: handle this case
      }
    }
  }

  Future<bool> checkAndRequestLocationPermision() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  getLocationStreamData() {
    location.onLocationChanged.listen((locationData) {});
  }

  void checkRequestUpdateLocation() async {
    await checkAndRequestLocationService();
    bool hasPermission = await checkAndRequestLocationPermision();
    if (hasPermission) {
      getLocationStreamData();
    } else {
      // TODO: handle this case
    }
  }
}
