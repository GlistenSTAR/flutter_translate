import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';

class SlipMoney extends StatefulWidget {
  SlipMoney({Key? key, required this.studentName, required this.data})
      : super(key: key);

  final String studentName;
  final Map<String, dynamic> data;

  @override
  _SlipMoneyState createState() => _SlipMoneyState();
}

class _SlipMoneyState extends State<SlipMoney> {
  final GlobalKey previewContainer = new GlobalKey();
  late double amount;
  late String appFee, tax, bankFee, total, today;

  @override
  void initState() {
    super.initState();

    String slot = widget.data["class_keetime"];
    String hour = widget.data["class_hour"];
    String price = widget.data["class_price_hour"];

    amount = (double.tryParse(slot) ?? 1) *
        (double.tryParse(hour) ?? 1) *
        (double.tryParse(price) ?? 1);

    double numAppFee = amount * 0.3;
    double numTax = amount * 0.03;
    double numBankFee = 30.0;
    double numTotal = amount - numAppFee - numTax - numBankFee;

    appFee = "-" + numAppFee.toStringAsFixed(2);
    tax = "-" + numTax.toStringAsFixed(2);
    bankFee = "-" + numBankFee.toStringAsFixed(2);
    total = numTotal.toStringAsFixed(2);

    DateFormat formatter = DateFormat("yyyy-MM-dd");
    today = formatter.format(Util.toBuddhist(DateTime.now()));

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Timer.periodic(Duration(seconds: 3), (timer) async {
        timer.cancel();
        File file = await takeScreenShot(previewContainer);
        Navigator.of(context).pop(file);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: RepaintBoundary(
          key: previewContainer,
          child: Column(
            children: [
              Text("ใบสำคัญรับเงิน (ติวเตอร์)"),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text("เลขที่อ้างอิง ${widget.data['transaction_id']}"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text("วันที่ $today"),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ชื่อผู้ชำระเงิน: บริษัท ทิวเทอร์เฮาส์ จำกัด"),
                    Text(
                        "ที่อยู่:  2088/293 อาคารซี ถนนพหลโยธิน แขวงเสนานิคม เขตจตุจักร กรุงเทพมหานคร"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ชื่อติวเตอร์ ${Globals.currentUser!.name}"),
                    Text("เลขที่บัตรประชาชน ${Globals.currentUser!.idCard}"),
                    Text("ที่อยู่ ${Globals.currentUser!.address}"),
                  ],
                ),
              ),
              Divider(height: 32),
              Text("รายละเอียดการรับเงิน"),
              SizedBox(height: 16),
              _detailRow("ชื่อนักเรียน:", widget.studentName),
              SizedBox(height: 4),
              _detailRow("วัน:", widget.data["class_date"]),
              SizedBox(height: 4),
              _detailRow("เวลา:", widget.data["class_time"]),
              SizedBox(height: 4),
              _detailRow("วิชา/ติวสอบ:", widget.data["class_title"]),
              SizedBox(height: 4),
              _detailRow("จำนวนชม./ครั้ง:", widget.data["class_hour"]),
              SizedBox(height: 4),
              _detailRow(
                  "จำนวนครั้ง:", widget.data["class_keetime"] + "   ครั้ง"),
              SizedBox(height: 4),
              _detailRow("ราคาต่อชั่วโมง:",
                  widget.data["class_price_hour"] + "   บาท"),
              SizedBox(height: 4),
              _detailRow("ราคารวมสุทธิ:", amount.toStringAsFixed(2) + "   บาท"),
              Divider(height: 32),
              Row(children: [
                Spacer(),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text("ราคารวม (ก่อนหักค่าธรรมเนียม) "),
                  SizedBox(height: 4),
                  Text("ค่าธรรมเนียมการใช้แอปพลิเคชั่น "),
                  SizedBox(height: 4),
                  Text("ภาษีหัก ณ ที่จ่าย 3% "),
                  SizedBox(height: 4),
                  Text("ค่าธรรมเนียมธนาคาร "),
                  SizedBox(height: 4),
                  Text(
                    "ราคารวมสุทธิ ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
                SizedBox(width: 16),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(amount.toStringAsFixed(2) + " บาท"),
                  SizedBox(height: 4),
                  Text("$appFee ครั้ง"),
                  SizedBox(height: 4),
                  Text("$tax บาท"),
                  SizedBox(height: 4),
                  Text("$bankFee บาท"),
                  SizedBox(height: 4),
                  Text(
                    "$total บาท",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
              ]),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ยืนยันการรับเงิน",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Globals.currentUser!.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("หมายเหตุ"),
                    Text("• เอกสารฉบับนี้ TUTOR HAUS"),
                    Text("  ออกให้กับติวเตอร์โดยอัตโนมัติ"),
                    SizedBox(height: 2),
                    Text("• ติวเตอร์จะได้รับเงินภายใน 24 ชม "),
                    Text("  หลังจากมีการยืนยันการรับเงิน"),
                    SizedBox(height: 2),
                    Text("• ติวเตอร์จะต้องแนบสำเนาบัตร"),
                    Text("  ประชาชนในโปรไฟล์เพื่อทำการรับเงิน"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String title, String description) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        SizedBox(width: 8),
        Expanded(child: Text(description)),
      ],
    );
  }

  Future<File> takeScreenShot(GlobalKey previewContainer) async {
    RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    // previewContainer.currentContext!.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // print(pngBytes);
    File imgFile = new File('$directory/screenshot.png');
    await imgFile.writeAsBytes(pngBytes);
    return imgFile;
  }
}
