import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:brbr/constants/colors.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/widgets/brbr_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BRBRBarcode {
  late String svg, otp;
  late DateTime expire;
  BRBRBarcode(this.svg, this.otp);
  BRBRBarcode.fromJson(String src) {
    Map<String, dynamic> srcMap = jsonDecode(src);
    svg = srcMap['svg']!;
    otp = srcMap['code']!;
    expire = DateTime.parse(srcMap['ttl']).toLocal();
  }
}

class BarcodePage extends StatefulWidget {
  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
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
              child: FutureBuilder(
                future: BRBRService.getBarcodeOTP(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    BRBRBarcode barcode = (snapshot.data as BRBRBarcode);
                    return Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BarcodeZone(barcode),
                            SizedBox(height: 24),
                            MaterialButton(
                              textColor: Colors.white,
                              color: BRBRColors.highlight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                              child: Container(
                                height: 48,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.refresh),
                                    SizedBox(width: 8),
                                    Text('재발급 하기', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarcodeZone extends StatefulWidget {
  final BRBRBarcode barcode;
  BarcodeZone(this.barcode);

  @override
  _BarcodeZoneState createState() => _BarcodeZoneState();
}

class _BarcodeZoneState extends State<BarcodeZone> {
  Duration _leftTime = Duration();
  late Timer timer;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _leftTime = widget.barcode.expire.difference(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_leftTime < Duration()) {
          return Text(
            '바코드가 만료되었습니다.\n바코드를 재발급 해주세요',
            style: TextStyle(fontSize: 20),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('남은시간 ${_leftTime.inSeconds}'),
                  BRBRCard(
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SvgPicture.string(widget.barcode.svg),
                          Text(widget.barcode.otp.toUpperCase()),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
              Text(
                '스테이션에 바코드를 태그하고 \n작은 변화를 실천해 보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(color: BRBRColors.secondaryText),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
