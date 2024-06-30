import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteViewBody extends StatefulWidget {
  const RouteViewBody({super.key});

  @override
  State<RouteViewBody> createState() => _RouteViewBodyState();
}

class _RouteViewBodyState extends State<RouteViewBody> {
  late CameraPosition initialCameraPosition;
  @override
  void initState() {
    super.initState();
    initCameraPosition();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      initialCameraPosition: initialCameraPosition,
    );
  }

  void initCameraPosition() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 1,
    );
  }
}
