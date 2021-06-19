import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyPointPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BRBRReceiptInfos receipts = context.watch<BRBRReceiptInfos>();
    return Scaffold(
      appBar: AppBar(
        title: Text('내 포인트'),
      ),
      body: RefreshIndicator(
        color: BRBRColors.highlight,
        onRefresh: () async {
          await context.read<BRBRReceiptInfos>().update();
        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text('${context.select<BRBRUser, String?>((user) => user.name) ?? '--'}님의 포인트', style: TextStyle(fontSize: 16, color: BRBRColors.secondaryText, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<BRBRReceiptInfos>(
                        builder: (context, value, child) {
                          return Text(
                            '${value.getTotalPoint() != null ? NumberFormat('###,###,###,###').format(value.getTotalPoint()) : '--'} 포인트',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      MaterialButton(
                        highlightElevation: 0,
                        child: Text('변환'),
                        minWidth: 0,
                        onPressed: () {},
                        color: BRBRColors.highlight,
                        elevation: 0,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Column(
              children: receipts.receipts?.map((e) => ReceiptTile(e)).toList() ?? [Container()],
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiptTile extends StatelessWidget {
  final BRBRReceipt receipt;

  ReceiptTile(this.receipt);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Text(
        DateFormat('M.dd').format(receipt.transactionAt),
        style: TextStyle(color: BRBRColors.secondaryText),
      ),
      title: Text(
        receipt.stationName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${receipt.getTotalWeight()}g',
        style: TextStyle(color: BRBRColors.secondaryText),
      ),
      trailing: Text(
        '${receipt.point} 포인트',
        style: TextStyle(color: BRBRColors.highlight, fontWeight: FontWeight.bold),
      ),
      onTap: () {},
    );
  }
}
