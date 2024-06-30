import 'package:flutter/material.dart';
import 'package:google_map_app/core/utils/exceptions.dart';
import 'package:google_map_app/core/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RouteViewBody extends StatefulWidget {
  const RouteViewBody({super.key});

  @override
  State<RouteViewBody> createState() => _RouteViewBodyState();
}

class _RouteViewBodyState extends State<RouteViewBody> {
  late CameraPosition initialCameraPosition;
  late LocationService location;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    initCameraPosition();
    location = LocationService(location: Location());
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      markers: markers,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {
        googleMapController = controller;
        updateCurrentLocation();
      },
    );
  }

  void initCameraPosition() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 1,
    );
  }

  void updateCurrentLocation() async {
    try {
      LocationData locationData = await location.getLocation();
      LatLng myLocationPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      addMarkerToMyLocation(myLocationPosition);
      await animateCameraToMyLocation(myLocationPosition);
    } on LocationServiceException catch (e) {
      // TODO
    } on LocationPermissioneException catch (e) {
      // TODO
    } catch (e) {
      // TODO
    }
  }

  void addMarkerToMyLocation(LatLng myLocationPosition) {
    Marker myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: myLocationPosition,
      infoWindow: const InfoWindow(title: 'My Location'),
    );
    markers.add(myLocationMarker);
    setState(() {});
  }

  Future<void> animateCameraToMyLocation(LatLng myLocationPosition) async {
    CameraPosition myCameraPosition = CameraPosition(
      target: myLocationPosition,
      zoom: 16,
    );
    await googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(myCameraPosition));
  }
}
