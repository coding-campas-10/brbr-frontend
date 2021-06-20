import 'package:flutter/material.dart';
import 'package:location/location.dart';

enum LocationServiceStatus {
  Enabled,
  GPSDisabled,
  PermissionNotAllowd,
  Disabled,
}

class LocationProvider extends ChangeNotifier {
  LocationData? _locationData;
  Location _location = Location();

  LocationProvider() {
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _locationData = currentLocation;
      print('${_locationData!.latitude}, ${_locationData!.longitude}');
      notifyListeners();
    });
  }

  LocationData? get locationData => _locationData;
  Future<LocationServiceStatus> isLocationAvailable() async {
    bool _isServiceEnabled = await _location.serviceEnabled();
    PermissionStatus _permissionStatus = await _location.hasPermission();
    if (_isServiceEnabled && (_permissionStatus == PermissionStatus.granted)) {
      return LocationServiceStatus.Enabled;
    } else if (_isServiceEnabled == false) {
      return LocationServiceStatus.GPSDisabled;
    } else if (_permissionStatus != PermissionStatus.granted) {
      return LocationServiceStatus.PermissionNotAllowd;
    } else {
      return LocationServiceStatus.Disabled;
    }
  }

  Future<bool> requestPermissionAndService() async {
    print('위치 정보 요청');
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      print('GPS 사용 요청');
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    print('위치 서비스 사용 가능');

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('GPS 권한 요청');
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    print('위치 서비스 권한 있음');

    return true;
  }

  Future<bool> updateLocation() async {
    bool locationAvailable = await requestPermissionAndService();
    if (locationAvailable) {
      _locationData = await _location.getLocation();
      notifyListeners();
      return false;
    } else {
      return false;
    }
  }
}
