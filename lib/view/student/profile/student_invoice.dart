import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutor/utils/globals.dart';

class StudentInvoice extends StatefulWidget {
  StudentInvoice(
      {Key? key,
      required this.tutorName,
      required this.tutorAddress,
      required this.data})
      : super(key: key);

  final String tutorName;
  final String tutorAddress;
  final Map<String, dynamic> data;

  @override
  _StudentInvoiceState createState() => _StudentInvoiceState();
}

class _StudentInvoiceState extends State<StudentInvoice> {
  final GlobalKey previewContainer = new GlobalKey();
  late double amount;

  @override
  void initState() {
    super.initState();

    String slot = widget.data["class_keetime"];
    String hour = widget.data["class_hour"];
    String price = widget.data["class_price_hour"];

    amount = (double.tryParse(slot) ?? 1) *
        (double.tryParse(hour) ?? 1) *
        (double.tryParse(price) ?? 1);

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
                child: Text("เลขที่อ้างอิง ${widget.data['transaction_id']}"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text("วันที่ ${widget.data['class_date']}"),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("ชื่อติวเตอร์ ${widget.tutorName}"),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("ที่อยู่ ${widget.tutorAddress}"),
              ),
              Divider(height: 32),
              Text("รายละเอียดคลาสเรียน"),
              SizedBox(height: 16),
              _detailRow("ชื่อนักเรียน:", Globals.currentUser!.name),
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
              Text("ยอดที่ชำระแล้วทั้งสิ้น ${amount.toStringAsFixed(2)} บาท"),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("หมายเหตุ"),
                  Text("• เอกสารฉบับนี้ TUTOR HAUS"),
                  Text("  ออกให้กับติวเตอร์โดยอัตโนมัติ"),
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
