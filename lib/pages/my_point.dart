import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_point.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPointPage extends StatelessWidget {
  final List<BRBRPoint> pointList = [
    BRBRPoint(date: DateTime(2021, 5, 10), stationId: '동탄 반송 3스테이션', weight: 500, point: 500),
    BRBRPoint(date: DateTime(2021, 5, 15), stationId: '동탄 반송 2스테이션', weight: 100, point: 100),
    BRBRPoint(date: DateTime(2021, 5, 18), stationId: '동탄 반송 5스테이션', weight: 120, point: 120),
    BRBRPoint(date: DateTime(2021, 5, 20), stationId: '동탄 반송 5스테이션', weight: 800, point: 800),
    BRBRPoint(date: DateTime(2021, 5, 21), stationId: '동탄 반송 5스테이션', weight: 1200, point: 1200),
    BRBRPoint(date: DateTime(2021, 5, 27), stationId: '동탄 반송 1스테이션', weight: 700, point: 700),
    BRBRPoint(date: DateTime(2021, 5, 29), stationId: '동탄 반송 3스테이션', weight: 650, point: 650),
    BRBRPoint(date: DateTime(2021, 5, 30), stationId: '동탄 반송 3스테이션', weight: 900, point: 900),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 포인트'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text('최진우님의 포인트', style: TextStyle(fontSize: 16, color: BRBRColors.secondaryText, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '23,200 포인트',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      highlightElevation: 0,
                      child: Text('변환'),
                      minWidth: 0,
                      onPressed: () {},
                      color: BRBRColors.highlight,
                      elevation: 0,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Column(
            children: pointList.map((e) => PointListtile(e)).toList(),
          ),
        ],
      ),
    );
  }
}

class PointListtile extends StatelessWidget {
  final BRBRPoint point;

  PointListtile(this.point);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Text(
        DateFormat('M.dd').format(point.date),
        style: TextStyle(color: BRBRColors.secondaryText),
      ),
      title: Text(
        point.stationId,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${point.weight}g',
        style: TextStyle(color: BRBRColors.secondaryText),
      ),
      trailing: Text(
        '${point.point} 포인트',
        style: TextStyle(color: BRBRColors.highlight, fontWeight: FontWeight.bold),
      ),
      onTap: () {},
    );
  }
}
