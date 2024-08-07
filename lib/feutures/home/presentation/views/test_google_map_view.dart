import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map_app/feutures/home/data/models/home_place_model.dart';
import 'package:google_map_app/feutures/home/presentation/manager/cubit/google_map_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TestGoogleMapView extends StatefulWidget {
  const TestGoogleMapView({super.key});

  @override
  State<TestGoogleMapView> createState() => _TestGoogleMapViewState();
}

class _TestGoogleMapViewState extends State<TestGoogleMapView> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<GoogleMapCubit>();
    cubit.initCameraPosition();
    cubit.initMapStyle(context: context);
    cubit.initGoogleMap();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleMapCubit, GoogleMapState>(
      builder: (context, state) {
        var cubit = context.read<GoogleMapCubit>();
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
              // polygons: cubit.polygons,
              circles: cubit.circles,
              polylines: cubit.polylines,
              markers: cubit.markers,
              style: cubit.mapStyle,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                cubit.mapController = controller;
                cubit.initMapStyle(context: context);
              },
              initialCameraPosition: cubit.initialCameraPosition,
            ),
            Positioned(
              bottom: 20,
              right: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  cubit.mapController.animateCamera(
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
      },
    );
  }
}
