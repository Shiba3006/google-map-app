import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_map_app/core/utils/app_constants.dart';
import 'package:google_map_app/feutures/home/data/models/place_model.dart';
import 'package:google_map_app/feutures/home/data/models/polygons_model.dart';
import 'package:google_map_app/feutures/home/data/models/polyline_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit() : super(GoogleMapInitial());
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;
  String? mapStyle;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};

  void initCameraPosition() {
    emit(InitCameraPositionLoadingState());
    try {
      initialCameraPosition = const CameraPosition(
        target: LatLng(29.99552098735423, 31.205921201848618),
        zoom: 12,
      );
      emit(InitCameraPositionSuccessState());
    } catch (e) {
      emit(InitCameraPositionFailureState());
    }
  }

  void initMapStyle({
    required BuildContext context,
  }) async {
    emit(InitMapStyleLoadingState());
    try {
      mapStyle = await DefaultAssetBundle.of(context)
          .loadString(AppConstants.hoperMapStyle);
      emit(InitMapStyleSuccessState());
    } catch (e) {
      emit(InitMapStyleFailureState());
    }
  }

  Future<void> initMarkers() async {
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
    Polyline polyline = Polyline(
      patterns: const [
        // change line pattern
        PatternItem.dot,
      ],
      width: 5, // change line width
      zIndex: 2,
      color: Colors.red,
      polylineId: PolylineId(myPolylines[0].id),
      points: myPolylines[0].points,
    );
    Polyline polyline2 = Polyline(
      zIndex: 1,
      startCap: Cap.roundCap, // change start cap
      endCap: Cap.roundCap,
      polylineId: PolylineId(myPolylines[1].id),
      points: myPolylines[1].points,
    );
    Polyline polyline3 = Polyline(
      geodesic: true, // for too long line give some curve.
      polylineId: PolylineId(myPolylines[2].id),
      points: myPolylines[2].points,
    );

    polylines.add(polyline);
    polylines.add(polyline2);
    polylines.add(polyline3);
  }

  void initPolyGons() {
    Polygon polygon = Polygon(
      holes: holes,
      fillColor: Colors.green.withOpacity(0.2),
      strokeColor: Colors.green,
      strokeWidth: 2,
      polygonId:  PolygonId(myPolygons[0].id),
      points: myPolygons[0].points,
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

  void initGoogleMap() async {
    emit(InitGoogleMapLoadingState());
    try {
      await initMarkers();
      initPolyLines();
      // initPolyGons();
      initCircles();
      emit(InitGoogleMapSuccessState());
    } catch (e) {
      emit(InitGoogleMapFailureState());
    }
  }
}
