import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_map_app/core/utils/api_service.dart';
import 'package:google_map_app/core/utils/app_constants.dart';
import 'package:google_map_app/core/utils/secret_keys.dart';
import 'package:google_map_app/feutures/route/data/models/place_details_model/place_details_model.dart';
import 'package:google_map_app/feutures/route/data/models/places_model/places_auto_complete_model.dart';

class GoogleMapsPlacesService {
  GoogleMapsPlacesService({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

  Future<List<PlaceModel>> getPredictions(
      {required String input, required String sessionToken}) async {
    var response = await _apiService.get(
      endPoint: 'autocomplete',
      extras: '&input=$input,&sessiontoken=$sessionToken',
    );
    if (response.statusCode == 200) {
      var data = response.data['predictions'];
      List<PlaceModel> places = [];
      for (var element in data) {
        places.add(PlaceModel.fromJson(element));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({required String placeId}) async {
    var response = await _apiService.get(
      endPoint: 'details',
      extras: '&place_id=$placeId',
    );

    if (response.statusCode == 200) {
      var data = response.data['result'];
      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
