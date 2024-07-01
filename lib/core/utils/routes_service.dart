import 'package:google_map_app/core/utils/api_service.dart';
import 'package:google_map_app/feutures/route/data/models/routes_input_model/routes_input_model.dart';
import 'package:google_map_app/feutures/route/data/models/routes_model/routes_model.dart';

class RoutesService {
  RoutesService({required ApiService apiService}) : _apiService = apiService;
  final ApiService _apiService;

  Future<RoutesModel> getRoutes({
    required RoutesInputModel routesInputs,
  }) async {
    var response = await _apiService.post(
      body: {
        "origin": routesInputs.origin!.toJson(),
        "destination": routesInputs.destination!.toJson(),
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE",
        "computeAlternativeRoutes": false,
        "routeModifiers": routesInputs.routeModifiers != null
            ? routesInputs.routeModifiers!.toJson()
            : RoutesInputModel().routeModifiers!.toJson(),
        "languageCode": "en-US",
        "units": "IMPERIAL"
      },
    );
    if (response.statusCode == 200) {
      var data = response.data['routes'];
      return RoutesModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
