import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng position;

  PlaceModel({required this.id, required this.name, required this.position});
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'Place 1',
    position: const LatLng(29.993559229264402, 31.20489934386751),
  ),
  PlaceModel(
    id: 2,
    name: 'Place 2',
    position: const LatLng(29.99549886249025, 31.208629125500657),
  ),
  PlaceModel(
    id: 3,
    name: 'Place 3',
    position: const LatLng(29.9952259886316, 31.203128123349508),
  ),
 
];
