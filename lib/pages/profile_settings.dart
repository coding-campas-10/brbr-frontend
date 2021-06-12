import 'package:brbr/models/brbr_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 프로필'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              child: Text('로그아웃'),
              onPressed: () async {
                await context.read<BRBRUser>().logout();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            MaterialButton(
              child: Text('회원 탈퇴', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await context.read<BRBRUser>().leave();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
