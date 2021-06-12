import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/pages/register.dart';
import 'package:brbr/services/brbr_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                try {
                  await context.read<BRBRUser>().login();
                } on NoSuchUserException catch (e) {
                  print(e.message);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(int.parse(e.kakaoUser.userID!), e.kakaoUser.userNickname!)));
                }
              },
              child: Text('카카오로 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
