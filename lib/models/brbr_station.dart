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

class Station extends StationLocation {
  late String stationName, description;
  Station({required int stationId, required double latitude, required double longtitude, required this.stationName, required this.description}) : super(stationId, latitude, longtitude);
  Station.fromMap(Map<String, dynamic> map) : super(map['station_id'], map['location']['coordinates'][0], map['location']['coordinates'][1]) {
    stationName = map['name'];
    description = map['description'];
  }
}
