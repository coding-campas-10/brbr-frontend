import 'dart:convert';
import 'package:brbr/pages/announce_detail.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class BRBRAnnounce {
  late String title, description, createdAt;
  late int announceId;
  BRBRAnnounce({required this.title, required this.description, required this.createdAt, required this.announceId});
  BRBRAnnounce.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['description'];
    createdAt = map['created_at'];
    announceId = map['announce_id'];
  }
}

class AnnouncePage extends StatelessWidget {
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
        future: BRBRService.getAnnounce(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<dynamic>? announces = snapshot.data as List<dynamic>?;
            if (announces != null) {
              return ListView.builder(
                itemCount: announces.length,
                itemBuilder: (context, index) {
                  String title = (announces[index] as BRBRAnnounce).title, contents = (announces[index] as BRBRAnnounce).description;
                  return ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AnnounceDetailPage(header: title, contents: contents)));
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('데이터를 불러오는 데 실패하였습니다!'));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
