import 'package:brbr/pages/faq.dart';
import 'package:brbr/pages/permision.dart';
import 'package:brbr/pages/policy.dart';
import 'package:brbr/pages/profile_settings.dart';
import 'package:brbr/pages/support.dart';
import 'package:brbr/pages/version_info.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 72),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '더보기',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        SizedBox(height: 24),
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

class _MoreActs extends StatelessWidget {
  final List<Map> _acts = [
    {'title': '계정', 'icon': Icon(Icons.person), 'link_page': ProfileSettingsPage()},
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
