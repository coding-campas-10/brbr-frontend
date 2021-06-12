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
      body: Center(
        child: MaterialButton(
          child: Text('로그아웃'),
          onPressed: () async {
            await context.read<BRBRUser>().logout();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
