import 'package:dio/dio.dart';
import 'package:google_map_app/core/utils/app_constants.dart';
import 'package:google_map_app/core/utils/secret_keys.dart';
import 'package:google_map_app/feutures/route/data/models/places_auto_complete_model/places_auto_complete_model.dart';

class GoogleMapsPlacesService {
  GoogleMapsPlacesService({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<PlacesAutoCompleteModel>> getPredictions(
      {required String input}) async {
    var response = await _dio.get(
        '${AppConstants.baseUrl}/autocomplete/json&key=${SecretKeys.placesRequestApiKey}&input=$input');
    if (response.statusCode == 200) {
      var data = response.data as Map<String, dynamic>;
      List<PlacesAutoCompleteModel> places =
          (data['predictions'] as List<dynamic>)
              .map((e) =>
                  PlacesAutoCompleteModel.fromJson(e as Map<String, dynamic>))
              .toList();
      return places;
    } else {
      return [];
    }
  }
}
