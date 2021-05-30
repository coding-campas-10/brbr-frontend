import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';

class UserReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('활동내역'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [BRBRCard()],
      ),
    );
  }
}
