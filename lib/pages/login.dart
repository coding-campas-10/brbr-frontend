import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/pages/register.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Image.asset(
                      'assets/BRBR_icon.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(height: 48),
                    Text('지금 널 버리러 가', style: TextStyle(color: BRBRColors.highlightText, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'GmarketSans')),
                    SizedBox(height: 8),
                    Text('버려버려', style: TextStyle(color: BRBRColors.highlight, fontWeight: FontWeight.w700, fontSize: 60, fontFamily: 'GmarketSans')),
                    SizedBox(height: 250),
                    MaterialButton(
                      height: 50,
                      color: Color.fromRGBO(254, 229, 0, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      onPressed: () async {
                        try {
                          await context.read<BRBRUser>().login();
                          context.read<BRBRReceiptInfos>().update();
                        } on NoSuchUserException catch (e) {
                          print(e.message);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(int.parse(e.kakaoUser.userID!), e.kakaoUser.userNickname!)));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            SvgPicture.asset('assets/kakao_logo.svg', height: 40),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '카카오 로그인',
                                  style: TextStyle(color: Color.fromRGBO(24, 22, 0, 1), fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '2021 © 고장난분무기',
                style: TextStyle(color: BRBRColors.secondaryText, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
