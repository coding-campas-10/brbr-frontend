import 'package:flutter/material.dart';

class VersionInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버전 정보'),
      ),
      body: Center(
        child: Text('0.1.0'),
      ),
    );
  }
}
