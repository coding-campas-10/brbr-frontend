import 'package:flutter/material.dart';

class NoticeDetailPage extends StatelessWidget {
  final String header, contents;

  NoticeDetailPage({required this.header, required this.contents});

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
