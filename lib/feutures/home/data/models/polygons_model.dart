import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonsModel {
  final String id;
  final List<LatLng> points;

  PolygonsModel({required this.id, required this.points});
}

List<PolygonsModel> myPolygons = [
  PolygonsModel(
    id: '1',
    points: [
      const LatLng(30.610462363797186, 32.134679993310485),
      const LatLng(30.46025148605027, 32.030041751175865),
      const LatLng(30.30980865034631, 29.518723939944863),
      const LatLng(28.853892460258102, 29.93727690848337),
    ],
  ),
];

List<List<LatLng>> holes = const [
  [
    LatLng(29.96613759704386, 31.233430099160845),
    LatLng(29.974984260067497, 31.230732531996825),
    LatLng(29.97999145603056, 31.22090568018503),
    LatLng(29.97097832156766, 31.225530081037643),
  ],
];
