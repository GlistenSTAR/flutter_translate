import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutor/model/user.dart';
import 'package:tutor/utils/globals.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage(
      {Key? key,
      required this.student,
      required this.transactionID,
      required this.qrCode,
      required this.slot,
      required this.data})
      : super(key: key);

  final User student;
  final String transactionID;
  final Image qrCode;
  final String slot;
  final Map<String, dynamic> data;

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final GlobalKey previewContainer = new GlobalKey();  
  late double amount;

  @override
  void initState() {
    super.initState();

    amount = widget.data["amount"];

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
              Text("ใบยืนยันคลาสเรียน"),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text("เลขที่อ้างอิง ${widget.transactionID}"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text("วันที่ ${widget.data['class_date']}"),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("ชื่อติวเตอร์ ${Globals.currentUser!.name}"),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("ที่อยู่ ${Globals.currentUser!.address}"),
              ),
              Divider(height: 32),
              Text("รายละเอียดคลาสเรียน"),
              SizedBox(height: 16),
              _detailRow("ชื่อนักเรียน:", widget.student.name),
              SizedBox(height: 4),
              _detailRow("วัน:", widget.data["class_date"]),
              SizedBox(height: 4),
              _detailRow("เวลา:", widget.data["class_time"]),
              SizedBox(height: 4),
              _detailRow("วิชา/ติวสอบ:", widget.data["class_title"]),
              SizedBox(height: 4),
              _detailRow("จำนวนชม./ครั้ง:", widget.data["class_hour"]),
              SizedBox(height: 4),
              _detailRow("จำนวนครั้ง:", widget.slot + "   ครั้ง"),
              SizedBox(height: 4),
              _detailRow("ราคาต่อชั่วโมง:",
                  widget.data["class_price_hour"] + "   บาท"),
              SizedBox(height: 4),
              _detailRow("ราคารวมสุทธิ:", amount.toStringAsFixed(2) + "   บาท"),
              Divider(height: 32),
              Text("ยอดที่ต้องชำระทั้งสิ้น $amount บาท\nชำระด้วย QR Code"),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.qrCode.image, fit: BoxFit.contain),
                ),
              ),
              Text("เลขที่อ้างอิง ${widget.transactionID}"),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("หมายเหตุ"),
                  Text("• เอกสารฉบับนี้ TUTOR HAUS"),
                  Text("  ออกให้กับติวเตอร์โดยอัตโนมัติ"),
                  SizedBox(height: 2),
                  Text("• การเลื่อนหรือยกเลิกคลาสเรียน"),
                  Text("  นักเรียนสามารถดูรายละเอียดได้จาก"),
                  Text("  จากเงื่อนไขและข้อตกลงในการใช้"),
                  Text("  บริการแอปพลิเคชั่น"),
                ],
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
