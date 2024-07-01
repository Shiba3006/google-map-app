import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_map_app/core/utils/google_maps_places_service.dart';
import 'package:google_map_app/feutures/home/presentation/manager/cubit/google_map_cubit.dart';
import 'package:google_map_app/feutures/home/presentation/views/location_view.dart';
import 'package:google_map_app/feutures/home/presentation/views/test_google_map_view.dart';
import 'package:google_map_app/feutures/route/feuters/views/route_view.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await GoogleMapsPlacesService(dio: Dio()).getPredictions(input: 'cairo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleMapCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const RouteView(),
      ),
    );
  }
}

/*
world view 0 -> 3
country view 4 -> 6
city view 10 -> 12
street view 13 -> 17
building view 18 -> 20
*/

/*
Using location:
1- inquire about location service.
2- request permission 
3- get location
4- display
*/
