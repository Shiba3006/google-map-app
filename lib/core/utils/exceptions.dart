class LocationServiceException implements Exception {
  final String errorMessage;

  LocationServiceException({required this.errorMessage});
}

class LocationPermissioneException implements Exception {
  final String errorMessage;

  LocationPermissioneException({required this.errorMessage});
}
