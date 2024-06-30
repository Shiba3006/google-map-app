import 'package:flutter/material.dart';
import 'package:google_map_app/core/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocatioViewBody extends StatefulWidget {
  const LocatioViewBody({super.key});

  @override
  State<LocatioViewBody> createState() => _LocatioViewBodyState();
}

class _LocatioViewBodyState extends State<LocatioViewBody> {
  late CameraPosition initialCameraPosition;
  GoogleMapController? mapController;
  bool isFirstCall = true;
  Set<Marker> markers = {};
  late LocationService locationService;
  @override
  void initState() {
    super.initState();
    locationService = LocationService(location: Location());
    initCameraPosition();
    checkRequestUpdateLocation();
  }

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {
        mapController = controller;
      },
    );
  }

  void initCameraPosition() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 1,
    );
  }

  void checkRequestUpdateLocation() async {
    await locationService.checkAndRequestLocationService();
    bool hasPermission =
        await locationService.checkAndRequestLocationPermision();
    if (hasPermission) {
      locationService.changeSettings(
        distanceFilter: 2,
        interval: 1000, // 1 second
      );
      locationService.getRealTimeLocayionData(onData: (locationData) {
        var myLocationPosition = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );
        setMyLocationMarker(myLocationPosition);
        updateMyCamera(myLocationPosition);
      });
    } else {
      // TODO: handle this case
    }
  }

  void updateMyCamera(LatLng myLocationPosition) {
    if (isFirstCall) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myLocationPosition,
            zoom: 15,
          ),
        ),
      );
      isFirstCall = false;
      setState(() {});
    } else {
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          myLocationPosition,
        ),
      );
    }
  }

  void setMyLocationMarker(LatLng myLocationPosition) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: myLocationPosition,
      infoWindow: const InfoWindow(title: 'My Location'),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }
}
