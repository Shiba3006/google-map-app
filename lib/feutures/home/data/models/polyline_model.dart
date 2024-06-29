import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineModel {
  final String id;
  final List<LatLng> points;

  PolylineModel({required this.id, required this.points});
}

List<PolylineModel> myPolylines = [
  PolylineModel(id: '1', points: [
    const LatLng(29.995268924135413, 31.206547564687774),
    const LatLng(29.995853928164028, 31.20535985577813),
    const LatLng(29.994805793500845, 31.204594318281856),
    const LatLng(29.99446941305363, 31.205388000539017),
  ]),
  PolylineModel(id: '2', points: [
    const LatLng(29.994767182783182, 31.206667836252358),
    const LatLng(29.996192947030305, 31.205082271931392),
  ]),
  PolylineModel(id: '3', points: [
    const LatLng(-75.212612825691, 25.812471650926497),
    const LatLng(82.3941812906896, 23.92083600204458),
  ]),
];
