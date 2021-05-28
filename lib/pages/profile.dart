import 'package:brbr/pages/faq.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';

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
          ),
        ),
        SizedBox(height: 16),
        ListTile(leading: Icon(Icons.person), title: Text('내 프로필'), onTap: () {}, contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        ListTile(leading: Icon(Icons.notifications), title: Text('알림'), onTap: () {}, contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        ListTile(leading: Icon(Icons.accessibility), title: Text('권한'), onTap: () {}, contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        ListTile(leading: Icon(Icons.support_agent), title: Text('고객 지원'), onTap: () {}, contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        ListTile(leading: Icon(Icons.receipt_long), title: Text('약관 및 정책'), onTap: () {}, contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        ListTile(leading: Icon(Icons.receipt_long), title: Text('버전 정보'), onTap: () {}, contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('FAQ'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FAQPage(),
                  ));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 24)),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '최진우님',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  MaterialButton(
                    onPressed: () {},
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
