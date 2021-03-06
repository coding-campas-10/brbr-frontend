import 'package:flutter/material.dart';

class AnnounceDetailPage extends StatelessWidget {
  final String title, contents;

  AnnounceDetailPage({required this.title, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 16,
              top: 16,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 88),
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    SizedBox(height: 24),
                    Text(contents, style: TextStyle(fontSize: 16, height: 1.3, color: Color.fromRGBO(0, 0, 0, 0.87))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
