import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';

class MyPoinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 포인트'),
      ),
      body: Column(
        children: [BRBRCard()],
      ),
    );
  }
}
