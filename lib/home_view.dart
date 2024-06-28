import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late CameraPosition initialCameraPosition;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
        target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(initialCameraPosition: initialCameraPosition);
  }
}
