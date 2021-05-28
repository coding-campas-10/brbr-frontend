import 'package:flutter/material.dart';

class FAQDetailPage extends StatelessWidget {
  final String header, contents;

  FAQDetailPage({this.header, this.contents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(header),
      ),
      body: Text(contents),
    );
  }
}
