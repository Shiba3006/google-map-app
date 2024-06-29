import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_map_app/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  String? mapStyle;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 15,
    );
    initMarkers();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  void initMapStyle() async {
    mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/google_map_styles/hoper_map_style.json');
    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(String path, double width) async {
    var imageData = await rootBundle.load(path);
    var imageCodec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width.round(),
    );
    var imageFrameInfo = await imageCodec.getNextFrame();
    var imageByteData = await imageFrameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return imageByteData!.buffer.asUint8List();
  }

  void initMarkers() async {
    var markerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'marker_icon.png',
    );
    var myMarker = places
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id.toString()),
            position: e.position,
            infoWindow: InfoWindow(title: e.name),
            icon: markerIcon,
          ),
        )
        .toSet();
    markers.addAll(myMarker);
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
          markers: markers,
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
            },
            child: const Text(
              'Change location',
            ),
          ),
        ),
      ],
    );
  }
}
