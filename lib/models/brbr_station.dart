import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class StationLocation {
  late double _latitude, _longtitude;
  late int stationId;
  StationLocation(this.stationId, this._latitude, this._longtitude);

  double get latitude => _latitude;
  double get longtitude => _longtitude;

  StationLocation.fromMap(Map<String, dynamic> map) {
    stationId = map['station_id'];
    _longtitude = map['location']['coordinates'][0];
    _latitude = map['location']['coordinates'][1];
  }
}

class Station extends StationLocation {
  late String stationName, description;
  Station({required int stationId, required double latitude, required double longtitude, required this.stationName, required this.description}) : super(stationId, latitude, longtitude);
  Station.fromMap(Map<String, dynamic> map) : super(map['station_id'], map['location']['coordinates'][1], map['location']['coordinates'][0]) {
    stationName = map['name'];
    description = map['description'];
  }

  double distanceFrom(double lat, double lon) {
    double lat2 = this._latitude, lon2 = this._longtitude;
    double dLat = _toRadians(lat2 - lat);
    double dLon = _toRadians(lon2 - lon);
    lat = _toRadians(lat);
    lat2 = _toRadians(lat2);
    double a = pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return 6372800 * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
