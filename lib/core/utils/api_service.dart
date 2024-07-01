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
        '${AppConstants.baseUrl}/$endPoint/json?key=${SecretKeys.placesRequestApiKey}$extras');

    return response;
  }
}
