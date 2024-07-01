import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map_app/core/utils/exceptions.dart';
import 'package:google_map_app/core/utils/google_maps_places_service.dart';
import 'package:google_map_app/core/utils/location_service.dart';
import 'package:google_map_app/core/widgets/custom_text_filed.dart';
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
  late TextEditingController controller;
  Set<Marker> markers = {};
  late GoogleMapsPlacesService googleMapsPlacesService;

  @override
  void initState() {
    super.initState();
    initCameraPosition();
    location = LocationService(location: Location());
    controller = TextEditingController();
    fetchPredictions();
  }

  void fetchPredictions() {
    if (controller.text.isNotEmpty) {
      controller.addListener(() async {
        var results = await googleMapsPlacesService.getPredictions(
            input: controller.text);
        log(results.toString());
      });
    }
  }

  @override
  void dispose() {
    googleMapController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            markers: markers,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              googleMapController = controller;
              updateCurrentLocation();
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: CustomTextField(
              controller: controller,
            ),
          ),
        ],
      ),
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
