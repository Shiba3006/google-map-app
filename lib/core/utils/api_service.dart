import 'package:dio/dio.dart';
import 'package:google_map_app/core/utils/app_constants.dart';
import 'package:google_map_app/core/utils/secret_keys.dart';

class ApiService {
  final Dio _dio;

  ApiService({required Dio dio}) : _dio = dio;

  Future<Response<dynamic>> get({
    required String endPoint,
    required String extras,
  }) async {
    var response = await _dio.get(
        '${AppConstants.placesBaseUrl}/$endPoint/json?key=${SecretKeys.placesRequestApiKey}$extras');

    return response;
  }

  Future<Response<dynamic>> post({
    required body,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': SecretKeys.placesRequestApiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
    };

    var response = await _dio.post(
      AppConstants.rotesBaseUrl,
      options: Options(
        headers: headers,
      ),
      data: body,
    );

    return response;
  }
}
