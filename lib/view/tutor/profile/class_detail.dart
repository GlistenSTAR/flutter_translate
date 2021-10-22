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
import 'package:tutor/view/student/profile/tutor_rating.dart';
import 'package:tutor/view/tutor/profile/slip_money.dart';
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
  String slipLink = "";

  @override
  void initState() {
    super.initState();
    model = widget.model;

    classRef = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(Globals.currentUser!.uid)
        .collection("Classes")
        .doc(model.id);
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
            String status;
            switch (data["class_status"] ?? "") {
              case "00":
                status = "จองแล้ว";
                break;
              case "pending":
                status = "รอการจ่ายเงิน";
                break;
              case "done":
                status = "สอนเสร็จ";
                break;
              default:
                status = "รอการยืนยันการเรียน";
                break;
            }

            bool allowLearing =
                status == "จองแล้ว" || status == "รอการยืนยันการเรียน";
            bool allowRequest = data["able_to_request_money"] ?? false;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
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
                            "ยืนยันการสอน",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Didn't teach?
                                    if (allowLearing) {
                                      await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FutureProgressDialog(
                                          updateTeaching(false),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "ไม่ได้สอน",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        allowLearing ? Colors.red : Colors.grey,
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
                                    if (allowLearing) {
                                      await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FutureProgressDialog(
                                          updateTeaching(true),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "สอนแล้ว",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: allowLearing
                                        ? Colors.green
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
                              "ส่งใบคำร้องโอนเงิน",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (slipLink.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    "ดาวน์โหลดเอกสาร",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      launch(slipLink);
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
                                        requestMoney();
                                      }
                                    },
                                    child: Text(
                                      "ยืนยัน",
                                      style: TextStyle(
                                        fontSize: 18,
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

  Future<void> updateTeaching(bool isDone) async {
    Map<String, dynamic> data = {"teach_done": isDone};

    var batch = FirebaseFirestore.instance.batch();
    batch.set(classRef, data, SetOptions(merge: true));
    batch.set(FirebaseFirestore.instance.collection("ClassIDs").doc(model.id),
        data, SetOptions(merge: true));
    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  Future<void> requestMoney() async {
    Map<String, dynamic> data = {"request_money": true};
    await classRef.set(data, SetOptions(merge: true));

    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("ClassIDs")
        .doc(model.id)
        .get();
    Map<String, dynamic> classData = document.data() as Map<String, dynamic>;
    dynamic file = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SlipMoney(studentName: model.studentName, data: classData),
      ),
    );

    if (file != null && file is File) {
      String downloadUrl = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.uploadImage(
            file,
            "tutor_slip",
            filename: classData["transaction_id"],
          ),
          message: Text('Please wait for a moment...'),
        ),
      );

      if (downloadUrl == "ERROR_UPLOAD_IMAGE") {
        showToast("Upload Failed");
      } else {
        setState(() {
          slipLink = downloadUrl;
        });
      }
    } else {
      print("Not received Slip image");
    }
  }
}
