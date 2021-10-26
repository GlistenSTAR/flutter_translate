import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/profile/student_invoice.dart';
import 'package:tutor/view/student/profile/tutor_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassDetail extends StatefulWidget {
  const ClassDetail({Key? key, required this.model}) : super(key: key);

  final ClassModel model;

  @override
  _ClassDetailState createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
  late ClassModel model;
  late DocumentReference classRef;
  String invoiceLink = "";

  @override
  void initState() {
    super.initState();
    model = widget.model;

    classRef = FirebaseFirestore.instance
        .collection("StudentIDs")
        .doc(Globals.currentUser!.uid)
        .collection("Classes")
        .doc(model.id);

    Map<String, dynamic> data = {"status_changed": false};
    Util.updateClass(model.id, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: COLOR.YELLOW,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: classRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            bool allowRequest;
            String status = data["class_status"];
            if (status == "00" || status == "done") {
              allowRequest = true;
            } else {
              allowRequest = false;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 2)
                      ],
                      color: Colors.white,
                    ),
                    child: Container(
                      height: 180,
                      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ยืนยันการเรียน",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Prompt',
                              letterSpacing: 0.12,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Didn't study?
                                    await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          FutureProgressDialog(
                                        updateLearing(false),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "ไม่ได้เรียน",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.12,
                                      fontFamily: 'Prompt',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Studied?
                                    await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          FutureProgressDialog(
                                        updateLearing(true),
                                      ),
                                    );
                                    showReminderDialog(context);
                                  },
                                  child: Text(
                                    "เรียนแล้ว",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.12,
                                      fontFamily: 'Prompt',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                        height: 180,
                        padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ขอใบเสร็จรับเงิน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.12,
                                fontFamily: 'Prompt',
                              ),
                            ),
                            if (invoiceLink.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    "ดาวน์โหลดเอกสาร",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      launch(invoiceLink);
                                    },
                                    child: Text(
                                      "Link",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //request a receipt
                                      if (allowRequest) {
                                        requestInvoice();
                                      }
                                    },
                                    child: Text(
                                      "ยืนยัน",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.12,
                                        fontFamily: 'Prompt',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: allowRequest
                                          ? COLOR.YELLOW
                                          : Colors.grey,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        buttonPadding: EdgeInsets.zero,
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "หลังจากเรียนเสร็จแล้ว\n",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Prompt',
              ),
              children: [
                TextSpan(
                  text: "อย่าลืมให้คะแนนและรีวิวติวเตอร์ด้วยนะ",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ]),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => TutorRating(model: model),
                  ),
                );
              },
              child: Text(
                "ตกลง",
                style: TextStyle(
                  color: COLOR.YELLOW,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateLearing(bool isDone) async {
    Map<String, dynamic> data = {"learn_done": isDone};

    var batch = FirebaseFirestore.instance.batch();
    batch.set(classRef, data, SetOptions(merge: true));
    batch.set(FirebaseFirestore.instance.collection("ClassIDs").doc(model.id),
        data, SetOptions(merge: true));
    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  Future<void> requestInvoice() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("ClassIDs")
        .doc(model.id)
        .get();
    Map<String, dynamic> classData = document.data() as Map<String, dynamic>;
    dynamic file = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentInvoice(
            tutorName: model.tutorName,
            tutorAddress: model.tutorAddress,
            data: classData),
      ),
    );

    if (file != null && file is File) {
      String downloadUrl = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.uploadImage(
            file,
            "student_invoice",
            filename: classData["transaction_id"],
          ),
          message: Text('Please wait for a moment...'),
        ),
      );

      if (downloadUrl == "ERROR_UPLOAD_IMAGE") {
        showToast("Upload Failed");
      } else {
        setState(() {
          invoiceLink = downloadUrl;
        });
      }
    } else {
      print("Not received Invoice image");
    }
  }
}
