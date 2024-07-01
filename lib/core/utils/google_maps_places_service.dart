import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_map_app/core/utils/app_constants.dart';
import 'package:google_map_app/core/utils/secret_keys.dart';
import 'package:google_map_app/feutures/route/data/models/places_model/places_auto_complete_model.dart';

class GoogleMapsPlacesService {
  GoogleMapsPlacesService({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<PlaceModel>> getPredictions({required String input}) async {
    var response = await _dio.get(
        '${AppConstants.baseUrl}/autocomplete/json?key=${SecretKeys.placesRequestApiKey}&input=$input');
    if (response.statusCode == 200) {
      var data = response.data['predictions'];

      List<PlaceModel> places = [];
      for (var element in data) {
        places.add(PlaceModel.fromJson(element));
      }
      return places;
    } else {
      return [];
    }
  }
}
