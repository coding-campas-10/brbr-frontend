import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/pages/barcode.dart';
import 'package:brbr/pages/my_point.dart';
import 'package:brbr/pages/announce.dart';
import 'package:brbr/pages/user_report.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

AppBar homePageAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.qr_code_scanner),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BarcodePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.notifications_none),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncePage()));
        },
      )
    ],
  );
}

class HomePage extends StatelessWidget {
  final String _adUrl = 'https://www.jakorea.org/front/community/user/noticeview.do?seq=1306&pseq=&searchText=hackathon&cPage=1&flag=&navDepth1=1&navDepth2=1&board_subtype=';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          context.select<BRBRUser, String?>((user) => user.name) ?? '--',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  '최근 이용 스테이션:동탄 반송 3 스테이션',
                  style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.6)),
                ),
                SizedBox(width: 16),
                Icon(Icons.arrow_forward_ios, size: 10, color: Color.fromRGBO(0, 0, 0, 0.6)),
              ],
            ),
          ),
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
                  Consumer<BRBRReceiptInfos>(
                    builder: (context, value, child) {
                      return Text(
                        value.getTotalPoint() != null ? NumberFormat('###,###,###,###').format(value.getTotalPoint()) : '--',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
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
          backgroundColor: BRBRColors.highlight,
          onTab: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyPointPage()));
          },
        ),
        SizedBox(height: 8),
        BRBRCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(text: context.select<BRBRUser, String?>((user) => user.name) ?? '--', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '님의 기록이에요'),
                  ],
                ),
              ),
              SizedBox(height: 8),
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
                        TextSpan(text: '${value.getTotalWeight() != null ? (value.getTotalWeight()! ~/ 1000).toString() : '--'}kg', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black)),
                        TextSpan(text: '/800kg'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          onTab: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserReportPage()));
          },
          padding: EdgeInsets.symmetric(vertical: 31, horizontal: 16),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: BRBRCard(
                  child: Stack(
                    children: [
                      Text('분리수거 정보 \n알아보기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Positioned(child: Icon(Icons.qr_code_scanner), right: 0, bottom: 0),
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
        SizedBox(height: 8),
        BRBRCard(
          child: Image.asset('assets/brbr_ad.png'),
          onTab: () async {
            await canLaunch(_adUrl) ? await launch(_adUrl) : print('링크로 이동할 수 없음');
          },
        ),
      ],
    );
  }
}
