import 'package:brbr/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BRBRApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
}

class BRBRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '버려버려',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, appBarTheme: AppBarTheme(backgroundColor: Colors.white, titleTextStyle: TextStyle(color: Colors.black))),
      home: LoginPage(),
    );
  }
}
