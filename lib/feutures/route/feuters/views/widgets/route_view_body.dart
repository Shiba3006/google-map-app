import 'dart:async';

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
  Timer? debounce;

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

  @override
  void dispose() {
    googleMapController.dispose();
    controller.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void fetchPredictions() {
    controller.addListener(() {
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(const Duration(milliseconds: 100), () async {
        sessionToken ??= uuid.v4();
        await mapServices.getPredictions(
          input: controller.text,
          sessionToken: sessionToken!,
          places: places,
        );
        setState(() {});
      });
    });
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
}
