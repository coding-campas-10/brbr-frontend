import 'package:brbr/pages/faq.dart';
import 'package:brbr/pages/notifications.dart';
import 'package:brbr/pages/permision.dart';
import 'package:brbr/pages/policy.dart';
import 'package:brbr/pages/profile_settings.dart';
import 'package:brbr/pages/support.dart';
import 'package:brbr/pages/user_report.dart';
import 'package:brbr/pages/version_info.dart';
import 'package:brbr/utils/services/brbr_auth.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar profilePageAppbar() {
  return AppBar(
    leading: IconButton(
      color: Colors.black,
      icon: Icon(Icons.menu),
      onPressed: () {},
    ),
    title: Text('마이 페이지'),
  );
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 24),
        _ProfileCard(),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: BRBRCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('내 활동'),
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
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            padding: EdgeInsets.all(16),
            onTab: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserReportPage()));
            },
          ),
        ),
        _MoreActs(),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: BRBRCard(
            child: Container(
              height: 100,
              child: Center(child: Text('배너 영역')),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<BRBRAuth>(
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value.userId),
                Row(
                  children: [
                    Text(
                      '최진우님',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    MaterialButton(
                      onPressed: () {
                        value.logout();
                      },
                      child: Text('로그 아웃'),
                    ),
                  ],
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
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.arrow_forward_ios, size: 12),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person_outline,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreActs extends StatelessWidget {
  final _acts = [
    {'title': '내 프로필', 'icon': Icon(Icons.person), 'link_page': ProfileSettingsPage()},
    {'title': '알림', 'icon': Icon(Icons.notifications), 'link_page': NotificationsPage()},
    {'title': '권한', 'icon': Icon(Icons.accessibility), 'link_page': PermissionPage()},
    {'title': '고객 지원', 'icon': Icon(Icons.support_agent), 'link_page': SupportPage()},
    {'title': '약관 및 정책', 'icon': Icon(Icons.receipt_long), 'link_page': PolicyPage()},
    {'title': '버전 정보', 'icon': Icon(Icons.info), 'link_page': VersionInfoPage()},
    {'title': 'FAQ', 'icon': Icon(Icons.help), 'link_page': FAQPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _acts
          .map(
            (act) => ListTile(
              title: Text(act['title']),
              leading: act['icon'],
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              onTap: () {
                if (act['link_page'] != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => act['link_page']));
                }
              },
            ),
          )
          .toList(),
    );
  }
}
