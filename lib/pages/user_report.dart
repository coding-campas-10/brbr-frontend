import 'package:brbr/constants/colors.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserReportPage extends StatelessWidget {
  UserReportPage() {
    // BRBRService.getMostVisitedStation().then((value) => print(value?.content()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리포트'),
      ),
      body: ListView(
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
                        Text('자주 방문한 스테이션', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BRBRColors.highlightText)),
                        SizedBox(height: 12),
                        Text('동탄 반송 3\n스테이션', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('총 7회', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BRBRColors.secondaryText)),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
                  ),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: BRBRCard(
                    child: Stack(
                      children: [
                        Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('내 주변 스테이션', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 16),
                                Text(
                                  '53m',
                                  style: TextStyle(color: BRBRColors.highlight, fontSize: 34, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                Text('동탄 반송 3 스테이션', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Positioned(child: Icon(Icons.arrow_forward_ios, size: 18), right: 0, bottom: 0),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
                  ),
                ),
              ),
            ],
          ),
          Image.asset('assets/trash_percentage.png', width: double.infinity),
          Image.asset('assets/trash_report.png'),
        ],
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
        Text('최진우님의 활동 기록', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 24),
        LinearPercentIndicator(
          lineHeight: 16,
          percent: 0.6,
          backgroundColor: Color.fromRGBO(229, 229, 229, 1),
          progressColor: BRBRColors.highlight,
        ),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Color.fromRGBO(170, 170, 170, 1), fontSize: 16),
            children: <TextSpan>[
              TextSpan(text: '500kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
              TextSpan(text: '/800kg'),
            ],
          ),
        ),
      ],
    );
  }
}
