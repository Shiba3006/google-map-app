import 'package:google_map_app/core/utils/location_service.dart';
import 'package:google_map_app/core/utils/places_service.dart';
import 'package:google_map_app/core/utils/routes_service.dart';

class MapServices {
  final LocationService locationService;
  final PlacesService placesService;
  final RoutesService routesService;

  MapServices(
      {required this.locationService,
      required this.placesService,
      required this.routesService});
}
