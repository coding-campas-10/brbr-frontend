import 'dart:convert';
import 'package:brbr/pages/faq_detail.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class FAQPage extends StatelessWidget {
  Future _readFAQ(String path) async {
    return jsonDecode(await rootBundle.loadString(path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
        ),
      ),
      body: FutureBuilder(
        initialData: [],
        future: _readFAQ('resources/faq.json'),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: (snapshot.data as List).length,
              itemBuilder: (context, index) {
                String title = ((snapshot.data as List)[index] as Map)['header'], contents = ((snapshot.data as List)[index] as Map)['contents'];
                return ListTile(
                  title: Text(title),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => FAQDetailPage(title: title, contents: contents),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('공지를 불러오는 데에 실패하였습니다!'));
          }
        },
      ),
    );
  }
}
