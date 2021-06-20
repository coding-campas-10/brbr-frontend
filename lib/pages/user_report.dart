import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:brbr/widgets/nearest_station.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class UserReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리포트'),
      ),
      body: RefreshIndicator(
        color: BRBRColors.highlight,
        onRefresh: () async {
          context.read<BRBRReceiptInfos>().clearInfos();
          await context.read<BRBRReceiptInfos>().update();
        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: 24),
            OverviewReport(),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: BRBRCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('자주 방문한 스테이션', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BRBRColors.highlightText)),
                          SizedBox(height: 12),
                          Text('동탄 반송 3\n스테이션', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('총 7회', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: BRBRColors.secondaryText)),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
                    ),
                  ),
                ),
                NearestStation(),
              ],
            ),
            SizedBox(height: 8),
            BRBRCard(child: Image.asset('assets/trash_percentage.png', width: double.infinity)),
            SizedBox(height: 8),
            BRBRCard(child: Image.asset('assets/trash_report.png')),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('5월 1주', style: TextStyle(fontSize: 11)),
                  Text('5월 2주', style: TextStyle(fontSize: 11)),
                  Text('5월 3주', style: TextStyle(fontSize: 11)),
                  Text('6월 1주', style: TextStyle(fontSize: 11)),
                  Text('6월 2주', style: TextStyle(fontSize: 11)),
                  Text('6월 3주', style: TextStyle(fontSize: 11)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OverviewReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${context.select<BRBRUser, String?>((user) => user.name) ?? '--'}님의 활동 기록', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 24),
        LinearPercentIndicator(
          lineHeight: 16,
          percent: 0.6,
          backgroundColor: Color.fromRGBO(229, 229, 229, 1),
          progressColor: BRBRColors.highlight,
        ),
        SizedBox(height: 16),
        Consumer<BRBRReceiptInfos>(
          builder: (context, value, child) {
            return RichText(
              text: TextSpan(
                style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1), fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: '${value.getTotalWeight() != null ? (value.getTotalWeight()! ~/ 1000).toString() : '--'}kg',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                  ),
                  TextSpan(text: '/800kg'),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
