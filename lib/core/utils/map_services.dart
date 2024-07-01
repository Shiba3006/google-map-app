import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_app/core/utils/location_service.dart';
import 'package:google_map_app/core/utils/places_service.dart';
import 'package:google_map_app/core/utils/routes_service.dart';
import 'package:google_map_app/feutures/route/data/models/place_details_model/place_details_model.dart';
import 'package:google_map_app/feutures/route/data/models/places_model/places_auto_complete_model.dart';
import 'package:google_map_app/feutures/route/data/models/routes_input_model/destination.dart';
import 'package:google_map_app/feutures/route/data/models/routes_input_model/lat_lng.dart';
import 'package:google_map_app/feutures/route/data/models/routes_input_model/location.dart';
import 'package:google_map_app/feutures/route/data/models/routes_input_model/origin.dart';
import 'package:google_map_app/feutures/route/data/models/routes_input_model/routes_input_model.dart';
import 'package:google_map_app/feutures/route/data/models/routes_model/routes_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapServices {
  MapServices(
      {required this.locationService,
      required this.placesService,
      required this.routesService});

  final LocationService locationService;
  final PlacesService placesService;
  final RoutesService routesService;

  LatLng? currentLocation;

  Future<void> getPredictions({
    required String input,
    required String sessionToken,
    required List<PlaceModel> places,
  }) async {
    if (input.isNotEmpty) {
      List<PlaceModel> results = await placesService.getPredictions(
        input: input,
        sessionToken: sessionToken,
      );
      places.clear();
      places.addAll(results);
      //var newList = places; // same ref
      //var newList2 = [...places]; // copy
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData({
    required LatLng currentDistination,
  }) async {
    Origin origin = Origin(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: currentLocation!.latitude,
          longitude: currentLocation!.longitude,
        ),
      ),
    );
    Destination distination = Destination(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: currentDistination.latitude,
          longitude: currentDistination.longitude,
        ),
      ),
    );
    RoutesModel routes = await routesService.fetchRoutes(
      routesInputs: RoutesInputModel(
        origin: origin,
        destination: distination,
      ),
    );
    var polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoutes(polylinePoints, routes);
    return points;
  }

  List<LatLng> getDecodedRoutes(
      PolylinePoints polylinePoints, RoutesModel routes) {
    List<PointLatLng> result = polylinePoints
        .decodePolyline(routes.routes![0].polyline!.encodedPolyline!);
    List<LatLng> points =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute({
    required List<LatLng> points,
    required Set<Polyline> polylines,
    required GoogleMapController googleMapController,
  }) {
    Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: points,
    );
    polylines.add(polyline);
    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongitude = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongitude = points.first.longitude;
    for (LatLng point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongitude = min(southWestLongitude, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongitude = max(northEastLongitude, point.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(southWestLatitude, southWestLongitude),
      northeast: LatLng(northEastLatitude, northEastLongitude),
    );
  }

  void updateCurrentLocation({
    required GoogleMapController googleMapController,
    required Set<Marker> markers,
    required Function onUpdate,
  }) {
    locationService.getRealTimeLocayionData(onData: (locationData) async {
      currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      addMarkerToMyLocation(
        myLocationPosition: currentLocation!,
        markers: markers,
      );
      await animateCameraToMyLocation(
        myLocationPosition: currentLocation!,
        googleMapController: googleMapController,
      );
      onUpdate();
    });
  }

  void addMarkerToMyLocation({
    required LatLng myLocationPosition,
    required Set<Marker> markers,
  }) {
    Marker myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: myLocationPosition,
      infoWindow: const InfoWindow(title: 'My Location'),
    );
    markers.add(myLocationMarker);
  }

  Future<void> animateCameraToMyLocation({
    required LatLng myLocationPosition,
    required GoogleMapController googleMapController,
  }) async {
    await googleMapController.animateCamera(
      CameraUpdate.newLatLng(myLocationPosition),
    );
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    return await placesService.getPlaceDetails(
      placeId: placeId,
    );
  }
}
