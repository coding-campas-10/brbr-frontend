class BRBRPoint {
  late DateTime date;
  late String stationId;
  late int weight, point;

  BRBRPoint({required DateTime date, required String stationId, required int weight, required int point}) {
    this.date = date;
    this.stationId = stationId;
    this.weight = weight;
    this.point = point;
  }
}
