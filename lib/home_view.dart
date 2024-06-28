import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  late String mapStyle;

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.995330581727064, 31.2059660027455),
      zoom: 11,
    );
    initMapStyle();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          /*
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: const LatLng(29.978939358240478, 31.16066904727755),
              northeast: const LatLng(30.095898566643577, 31.302491311725433),
            ),
          ),
          */
          // mapType: MapType.hybrid,
          style: mapStyle,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            mapController = controller;
            initMapStyle();
          },
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.newLatLng(
                  const LatLng(30.29695379175755, 31.768373079394056),
                ),
              );
              setState(() {});
            },
            child: const Text(
              'Change location',
            ),
          ),
        ),
      ],
    );
  }

  void initMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/google_map_styles/night_map_style.json');
  }
}
