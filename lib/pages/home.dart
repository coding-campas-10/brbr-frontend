import 'package:brbr/pages/my_point.dart';
import 'package:brbr/pages/notice.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

AppBar homePageAppBar() {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {},
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        BRBRCard(
          child: Center(
            child: Text(
              '동탄 반송 5 스테이션 신규 설치 안내',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          padding: EdgeInsets.all(16),
          onTab: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NoticePage()));
          },
        ),
        SizedBox(height: 16),
        BRBRCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(text: '최진우', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '님의 기록이에요'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              LinearPercentIndicator(
                lineHeight: 16,
                percent: 0.6,
                backgroundColor: Color.fromRGBO(229, 229, 229, 1),
                progressColor: Color.fromRGBO(0, 227, 147, 1),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [IconButton(icon: Icon(Icons.qr_code_scanner), onPressed: () {})],
              )
            ],
          ),
          padding: EdgeInsets.all(16),
        ),
        SizedBox(height: 16),
        BRBRCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 포인트',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '23,200원',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          backgroundColor: Color.fromRGBO(0, 227, 147, 1),
          onTab: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyPoinPage()));
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: BRBRCard(
                  child: Stack(
                    children: [
                      Text('분리수거 정보 알아보기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Positioned(child: Icon(Icons.qr_code_scanner), right: 0, bottom: 0),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: BRBRCard(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('가까운 스테이션 안내', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          Text(
                            '53m',
                            style: TextStyle(color: Color.fromRGBO(0, 227, 147, 1), fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text('동탄 반송 3 스테이션', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
        BRBRCard(
          child: Container(
            height: 100,
            child: Center(child: Text('배너 영역')),
          ),
        ),
      ],
    );
  }
}
