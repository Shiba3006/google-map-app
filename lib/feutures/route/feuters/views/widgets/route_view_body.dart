
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_map_app/core/utils/api_service.dart';
import 'package:google_map_app/core/utils/exceptions.dart';
import 'package:google_map_app/core/utils/map_services.dart';
import 'package:google_map_app/core/utils/places_service.dart';
import 'package:google_map_app/core/utils/location_service.dart';
import 'package:google_map_app/core/utils/routes_service.dart';
import 'package:google_map_app/core/widgets/custom_text_filed.dart';
import 'package:google_map_app/core/widgets/search_list_view.dart';
import 'package:google_map_app/feutures/route/data/models/places_model/places_auto_complete_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class RouteViewBody extends StatefulWidget {
  const RouteViewBody({super.key});

  @override
  State<RouteViewBody> createState() => _RouteViewBodyState();
}

class _RouteViewBodyState extends State<RouteViewBody> {
  late CameraPosition initialCameraPosition;

  late GoogleMapController googleMapController;
  late TextEditingController controller;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  List<PlaceModel> places = [];
  late Uuid uuid;
  String? sessionToken;

  late LatLng currentLocation;
  late LatLng currentDistination;
  late MapServices mapServices;
  @override
  void initState() {
    super.initState();
    uuid = const Uuid();
    controller = TextEditingController();
    initCameraPosition();
    fetchPredictions();
    mapServices = MapServices(
      locationService: LocationService(location: Location()),
      placesService: PlacesService(apiService: ApiService(dio: Dio())),
      routesService: RoutesService(apiService: ApiService(dio: Dio())),
    );
  }

  void fetchPredictions() {
    controller.addListener(() async {
      sessionToken ??= uuid.v4();
      await mapServices.getPredictions(
        input: controller.text,
        sessionToken: sessionToken!,
        places: places,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    googleMapController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            polylines: polylines,
            zoomControlsEnabled: false,
            markers: markers,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              googleMapController = controller;
              updateCurrentLocation();
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: Column(
              children: [
                SearchTextField(
                  controller: controller,
                ),
                const SizedBox(height: 10),
                SearchListView(
                  places: places,
                  mapServices: mapServices,
                  onPlaceSelected: (placeDetails) async {
                    controller.clear();
                    places.clear();
                    sessionToken = null;
                    currentDistination = LatLng(
                      placeDetails.geometry!.location!.lat!,
                      placeDetails.geometry!.location!.lng!,
                    );

                    var points = await mapServices.getRouteData(
                      currentLocation: currentLocation,
                      currentDistination: currentDistination,
                    );
                    mapServices.displayRoute(
                      points: points,
                      polylines: polylines,
                      googleMapController: googleMapController,
                    );
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void initCameraPosition() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(29.99552098735423, 31.205921201848618),
      zoom: 1,
    );
  }

  void updateCurrentLocation() async {
    try {
      currentLocation = await mapServices.updateCurrentLocation(
        googleMapController: googleMapController,
        markers: markers,
      );
      setState(() {});
    } on LocationServiceException catch (e) {
      // TODO
    } on LocationPermissioneException catch (e) {
      // TODO
    } catch (e) {
      // TODO
    }
  }
/*
  Future<List<LatLng>> getRouteData() async {
    Origin origin = Origin(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
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

  void displayRoute(List<LatLng> points) {
    Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: points,
    );
    polylines.add(polyline);
    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 32));
    setState(() {});
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
  */
}
