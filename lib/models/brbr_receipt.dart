import 'package:brbr/services/brbr_service.dart';
import 'package:flutter/material.dart';

class BRBRReceipt {
  late String id, stationName;
  late DateTime transactionAt;
  late int stationId, point, plasticWeight, paperWeight, glassWeight, styrofoamWeight, etcWeight;
  BRBRReceipt({required this.id, required this.transactionAt, required this.stationId, required this.point, required this.stationName, this.plasticWeight = 0, this.paperWeight = 0, this.glassWeight = 0, this.styrofoamWeight = 0, this.etcWeight = 0});
  BRBRReceipt.fromMap(Map map) {
    this.id = map['_id'];
    this.transactionAt = DateTime.parse(map['transaction_at']).toLocal();
    this.stationId = map['station_id'];
    this.stationName = map['station_name'];
    this.point = map['point'];
    this.plasticWeight = map['plastic_weight'] ?? 0;
    this.paperWeight = map['paper_weight'] ?? 0;
    this.glassWeight = map['glass_weight'] ?? 0;
    this.styrofoamWeight = map['styrofoam_weight'] ?? 0;
    this.etcWeight = map['etc_weight'] ?? 0;
  }

  int getTotalWeight() {
    return plasticWeight + paperWeight + glassWeight + styrofoamWeight + etcWeight;
  }
}

class BRBRReceiptInfos extends ChangeNotifier {
  List<BRBRReceipt>? _receipts;
  Future update() async {
    _receipts = await BRBRService.getAllReceipt();
    notifyListeners();
  }

  List<BRBRReceipt>? get receipts => _receipts;

  int? getTotalPoint() {
    if (_receipts != null) {
      int sum = 0;
      for (var r in receipts!) {
        sum += r.point;
      }
      return sum;
    }
  }

  int? getTotalWeight() {
    if (_receipts != null) {
      int sum = 0;
      for (var r in _receipts!) {
        sum += r.getTotalWeight();
      }
      return sum;
    }
  }

  void clearInfos() {
    _receipts = null;
    notifyListeners();
  }
}

// {
//     "_id": "60b8bfa5c47ba80eee744b23",
//     "station_id": 4,
//     "point": 9,
//     "plastic_weight": 12,
//     "paper_weight": 32,
//     "glass_weight": 8,
//     "styrofoam_weight": 64,
//     "etc_weight": 4,
//     "transaction_at": "2021-06-03T11:40:21.876Z"
//   },
