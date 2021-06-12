import 'dart:convert';
import 'dart:ui';

import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BRBRBarcode {
  late String svg, otp;
  BRBRBarcode(this.svg, this.otp);
  BRBRBarcode.fromJson(String src) {
    Map<String, dynamic> srcMap = jsonDecode(src);
    svg = srcMap['svg']!;
    otp = srcMap['code']!;
  }
}

class BarcodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: BRBRService.getBarcodeOTP(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            BRBRBarcode barcode = (snapshot.data as BRBRBarcode);
            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BRBRCard(
                    child: Column(
                      children: [
                        SvgPicture.string(barcode.svg),
                        Text(barcode.otp),
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
