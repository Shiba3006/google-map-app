import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_map_app/feutures/home/data/models/place_model.dart';
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
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};

  @override
  void initState() {
    super.initState();
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 12,
    );
    initMarkers();
    initPolyLines();
    // initPolyGons();
    initCircles();
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

/*
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
*/
  void initMarkers() async {
    var markerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      'assets/icons/marker_icon.png',
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

  void initPolyLines() {
    Polyline polyline = const Polyline(
      patterns: [
        // change line pattern
        PatternItem.dot,
      ],
      width: 5, // change line width

      zIndex: 2,
      color: Colors.red,
      polylineId: PolylineId('1'),
      points: [
        LatLng(29.995268924135413, 31.206547564687774),
        LatLng(29.995853928164028, 31.20535985577813),
        LatLng(29.994805793500845, 31.204594318281856),
        LatLng(29.99446941305363, 31.205388000539017),
      ],
    );
    Polyline polyline2 = const Polyline(
      zIndex: 1,
      startCap: Cap.roundCap, // change start cap
      endCap: Cap.roundCap,
      polylineId: PolylineId('2'),
      points: [
        LatLng(29.994767182783182, 31.206667836252358),
        LatLng(29.996192947030305, 31.205082271931392),
      ],
    );
    Polyline polyline3 = const Polyline(
      geodesic: true, // for too long line give some curve.
      polylineId: PolylineId('3'),
      points: [
        LatLng(-75.212612825691, 25.812471650926497),
        LatLng(82.3941812906896, 23.92083600204458),
      ],
    );
    polylines.add(polyline);
    polylines.add(polyline2);
    polylines.add(polyline3);
  }

  void initPolyGons() {
    Polygon polygon = Polygon(
      holes: const [
        [
          LatLng(29.96613759704386, 31.233430099160845),
          LatLng(29.974984260067497, 31.230732531996825),
          LatLng(29.97999145603056, 31.22090568018503),
          LatLng(29.97097832156766, 31.225530081037643),
        ],
      ],
      fillColor: Colors.green.withOpacity(0.2),
      strokeColor: Colors.green,
      strokeWidth: 2,
      polygonId: const PolygonId('1'),
      points: const [
        LatLng(30.610462363797186, 32.134679993310485),
        LatLng(30.46025148605027, 32.030041751175865),
        LatLng(30.30980865034631, 29.518723939944863),
        LatLng(28.853892460258102, 29.93727690848337),
      ],
    );
    polygons.add(polygon);
  }

  void initCircles() {
    circles.add(
      Circle(
        circleId: const CircleId('1'),
        center: const LatLng(29.993528625268983, 31.20492801322981),
        radius: 2000,
        fillColor: Colors.red.withOpacity(0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
      ),
    );
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
          circles: circles,
          // polygons: polygons,
          polylines: polylines,
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
