import 'dart:ui';

import 'package:brbr/services/brbr_auth.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarcodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: BRBRService.getBarcodeOTP(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String barcode = (snapshot.data as String);
            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BRBRCard(
                    child: Column(
                      children: [
                        SvgPicture.string(barcode),
                        Text('BL75EYMM6S'),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text('스테이션에 바코드를 태그하고 \n작은 변화를 실천해 보세요!', textAlign: TextAlign.center),
                ],
              ),
            );
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
