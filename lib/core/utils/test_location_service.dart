import 'package:location/location.dart';

class TestLocationService {
  final Location _location;

  TestLocationService({required Location location}) : _location = location;

  Future<bool> checkAndRequestLocationService() async {
    bool isServiceEnabled = await _location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await _location.requestService();
      if (!isServiceEnabled) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkAndRequestLocationPermision() async {
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    }
    return true;
  }

  void getRealTimeLocayionData({required void Function(LocationData)? onData}) {
    _location.onLocationChanged.listen(onData);
  }

  void changeSettings({required double distanceFilter, required int interval}) {
    _location.changeSettings(
        distanceFilter: distanceFilter, interval: interval);
  }

  Future<LocationData> getLocation() {
    return _location.getLocation();
  }
}
