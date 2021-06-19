class StationLocation {
  late double latitude, longtitude;
  late int stationId;
  StationLocation(this.stationId, this.latitude, this.longtitude);

  StationLocation.fromMap(Map<String, dynamic> map) {
    stationId = map['station_id'];
    longtitude = map['location']['coordinates'][0];
    latitude = map['location']['coordinates'][1];
  }
}
