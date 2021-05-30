import 'dart:convert';
import 'package:brbr/pages/notice_detail.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class NoticePage extends StatelessWidget {
  Future _readFAQ(String path) async {
    return jsonDecode(await rootBundle.loadString(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '공지사항',
        ),
      ),
      body: FutureBuilder(
        initialData: [],
        future: _readFAQ('resources/notice.json'),
        builder: (context, snapshot) => ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            String header = (snapshot.data[index] as Map)['header'], contents = (snapshot.data[index] as Map)['contents'];
            return ListTile(
              title: Text(header),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeDetailPage(header: header, contents: contents)));
              },
            );
          },
        ),
      ),
    );
  }
}
