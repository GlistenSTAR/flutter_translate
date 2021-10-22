import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:tutor/model/MessageModel.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/model/user.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/chat/full_screen.dart';
import 'package:tutor/view/student/chat/invoice_page.dart';
import 'package:tutor/view/student/chat/receipt_page.dart';
import 'package:tutor/view/student/search/tutor_time.dart';
import 'package:tutor/view/tutor/schedule/schedule_view.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    Key? key,
    required this.requestID,
    required this.roomID,
    required this.partner,
    required this.location,
    this.begintText,
  }) : super(key: key);

  final String requestID;
  final String roomID;
  final User partner;
  final String location;
  final String? begintText;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final teController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  late CollectionReference chatCollectionRef;
  late DocumentReference tutorRecentRef, studentRecentRef;

  late User partner;
  late StreamSubscription transactionSubscription;

  late TutorCardModel tutorCardModel;

  final List<String> wordGroups = [
    "email",
    "mail",
    "phonenumber",
    "phone",
    "number",
    "call",
    "LINE",
    "Facebook",
    "Instagram",
    "Twitter",
    "Whatsapp",
    "FB",
    "IG",
    "อีเมล",
    "เมล",
    "เบอร์โทร",
    "ร์โทรศัพท์",
    "โทรศัพท์",
    "เบอร์",
    "โทร",
    "อีเมล",
    "ไลน์",
    "ไลน",
    "เฟสบุค",
    "เฟส",
    "อินสตาแกรม",
    "ทวิตเตอร์",
    "วอทแอป",
    "โทร",
    "เบอร์โทร",
    "เบอ",
    "ไอจี"
  ];

  @override
  void initState() {
    super.initState();
    partner = widget.partner;
    chatCollectionRef = FirebaseFirestore.instance
        .collection("Application")
        .doc("Chat")
        .collection(widget.roomID);

    var batch = FirebaseFirestore.instance.batch();
    Map<String, dynamic> partnerData = {
      "user_id": partner.uid,
      "nickname": partner.nickname,
      "display_img": partner.profileUrl
    };

    Map<String, dynamic> myData = {
      "user_id": Globals.currentUser!.uid,
      "nickname": Globals.currentUser!.nickname,
      "display_img": Globals.currentUser!.profileUrl
    };

    if (partner.isTutor) {
      tutorRecentRef = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(partner.uid)
          .collection("RecentChats")
          .doc(widget.roomID);
      studentRecentRef = FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(Globals.currentUser!.uid)
          .collection("RecentChats")
          .doc(widget.roomID);

      batch.set(tutorRecentRef, myData, SetOptions(merge: true));
      batch.set(studentRecentRef, partnerData, SetOptions(merge: true));
    } else {
      tutorRecentRef = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(Globals.currentUser!.uid)
          .collection("RecentChats")
          .doc(widget.roomID);
      studentRecentRef = FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(partner.uid)
          .collection("RecentChats")
          .doc(widget.roomID);

      batch.set(tutorRecentRef, partnerData, SetOptions(merge: true));
      batch.set(studentRecentRef, myData, SetOptions(merge: true));
    }

    batch.commit().then((value) {}, onError: (e) {
      print(e);
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.begintText != null && widget.begintText!.isNotEmpty) {
        print(widget.begintText);
        onSendMessage(widget.begintText!, "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: COLOR.YELLOW,
          ),
        ),
        title: Text(
          partner.nickname,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showReportDialog,
            icon: Icon(
              Icons.chat_bubble_outline,
              color: COLOR.YELLOW,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // List of messages
          _buildListMessageWidget(),

          // Input content
          _buildInputWidget(),
        ],
      ),
    );
  }

  Widget _buildListMessageWidget() {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
          stream: chatCollectionRef
              .orderBy("timeStamp", descending: false)
              .limit(20)
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  MessageModel model = MessageModel.fromJson(data);

                  return _buildItemWidget(model);
                },
                itemCount: snapshot.data!.docs.length,
                controller: listScrollController,
              );
            } else if (snapshot.hasError) {
              // return snapshot.error;
              return Container();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _buildItemWidget(MessageModel model) {
    bool isMine = model.userID == Globals.currentUser!.uid;

    if (isMine) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: model.image.isEmpty
                      ? Text(
                          model.msg,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )
                      : _imageWidget(model.image),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: COLOR.LIGHT_GREY,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 4.0, left: 60),
                ),
                Text(
                  DateFormat.Hm("en").format(model.timeStamp),
                  style: TextStyle(color: COLOR.DARK_GREY),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Globals.currentUser!.profileUrl.isEmpty
              ? Image.asset(
                  "images/common/logo.png",
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                )
              : Container(
                  width: 60,
                  height: 60,
                  child: CachedNetworkImage(
                    imageUrl: Globals.currentUser!.profileUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => ClipOval(
                      child: Image.asset(
                        "images/common/logo.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Row(
        children: <Widget>[
          partner.profileUrl.isEmpty
              ? Image.asset(
                  "images/common/logo.png",
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                )
              : Container(
                  width: 60,
                  height: 60,
                  child: CachedNetworkImage(
                    imageUrl: partner.profileUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => ClipOval(
                      child: Image.asset(
                        "images/common/logo.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),
          SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: model.image.isEmpty
                      ? Text(
                          model.msg,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )
                      : _imageWidget(model.image),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                    color: model.image.isEmpty ? COLOR.YELLOW : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 4.0, right: 60),
                ),
                Text(
                  DateFormat.Hm("en").format(model.timeStamp),
                  style: TextStyle(color: COLOR.DARK_GREY),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  Widget _imageWidget(String url) {
    return Container(
      width: 200,
      height: 200,
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  FullScreen(provider: imageProvider, url: url),
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            ),
          ),
        ),
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => ClipOval(
          child: Image.asset(
            "images/common/logo.png",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }

  Widget _buildInputWidget() {
    return Container(
      alignment: Alignment.center,
      height: 80,
      padding: EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: <Widget>[
          //Book Button
          if (Globals.currentUser!.isTutor)
            Container(
              padding: EdgeInsets.only(left: 8),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () async {
                  dynamic result = await Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black54,
                        pageBuilder: (_, __, ___) => ReceiptPage()),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    String transactionID = await showDialog(
                      context: context,
                      builder: (context) => FutureProgressDialog(
                        createTransaction(result["amount"]),
                        message: Text('Please wait for a moment...'),
                      ),
                    );

                    if (transactionID == "Error") {
                      showToast("Connection Error");
                      return;
                    }

                    int slot = 1;

                    listenToPaymentQR(transactionID, (qrcode) async {
                      dynamic file = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => InvoicePage(
                                  student: partner,
                                  transactionID: transactionID,
                                  qrCode: qrcode,
                                  slot: slot.toString(),
                                  data: result)));

                      if (file != null && file is File) {
                        String downloadUrl = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Util.uploadImage(
                              file,
                              "tutor_invoice",
                              filename: transactionID,
                            ),
                            message: Text('Please wait for a moment...'),
                          ),
                        );

                        if (downloadUrl == "ERROR_UPLOAD_IMAGE") {
                          // showToast("Upload Failed");
                          downloadUrl =
                              "https://firebasestorage.googleapis.com/v0/b/tutorhaus-ba250.appspot.com/o/FailInvoice.jpg?alt=media&token=7398618f-e51d-41ff-9193-9dc8b4a54747";
                        }

                        // Send Invoice to Student from Tutor
                        Map<String, dynamic> messageData = {
                          "user": Globals.currentUser!.uid,
                          "msg": "",
                          "image": downloadUrl,
                          "timeStamp": DateTime.now(),
                        };

                        String timestamp =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        var batch = FirebaseFirestore.instance.batch();
                        batch.set(
                            chatCollectionRef.doc(timestamp), messageData);
                        await batch.commit().then((value) {}, onError: (e) {
                          print(e);
                        });

                        ///////////////
                        //Create Class
                        result.remove("amount");

                        Map<String, dynamic> additional = {
                          "class_keetime": slot.toString(),
                          "student_id": partner.uid,
                          "tutor_id": Globals.currentUser!.uid,
                          "type": 2,
                          "transaction_id": transactionID,
                          "location": widget.location,
                        };
                        result.addAll(additional);
                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            createClass(transactionID, result),
                            message: Text('Please wait for a moment...'),
                          ),
                        );
                      } else {
                        print("Not received Invoice image");
                      }
                    });
                  }
                },
                child: Image.asset("images/common/book.png"),
              ),
            )
          else
            Container(
              padding: EdgeInsets.only(left: 8),
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () async {
                  //Student re-booking
                  print("Student are booking");
                  dynamic profile = await Util.getTutorProfile(partner.uid);
                  if (profile is TutorCardModel) {
                    TutorCardModel model = profile;
                    dynamic result = await Navigator.of(context).push(
                      PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.black54,
                          pageBuilder: (_, __, ___) => TutorTime(model: model)),
                    );
                  }
                },
                child: Image.asset("images/common/rebook.png"),
              ),
            ),
          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 50,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.grey.shade300,
                      spreadRadius: 1,
                      blurRadius: 2)
                ],
              ),
              child: TextField(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.center,
                controller: teController,
                decoration: InputDecoration(
                  border: InputBorder.none,
//                  hintText: 'ใส่ข้อความ',
                  hintText: 'Enter Message',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: () {
                      onSendMessage(teController.text.trim(), "");
                    },
                    icon: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 10,
                        child: Icon(
                          Icons.send,
                          size: 24,
                          color: COLOR.YELLOW,
                        )),
                  ),
                ),
              ),
            ),
          ),
          // // Button send message
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 8.0),
          //     child: IconButton(
          //       icon: Icon(Icons.send),
          //       onPressed: () => onSendMessage(teController.text.trim(), ""),
          //       color: COLOR.YELLOW,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void onSendMessage(String message, String image) async {
    if (message.isEmpty && image.isEmpty) {
      showToast("Nothing to send");
      return;
    }

    teController.clear();
    if (EmailValidator.validate(message)) {
      showToast("You are not allow to send email address");
      return;
    }

    String? stopWord = checkStopWord(message);
    if (stopWord != null) {
      showToast("You are not allow to send $stopWord");
      return;
    }

    Map<String, dynamic> messageData = {
      "user": Globals.currentUser!.uid,
      "msg": message,
      "image": image,
      "timeStamp": DateTime.now(),
    };

    String lastMessage = message.isNotEmpty ? message : "image";
    Map<String, dynamic> lastData = {
      "last_msg": lastMessage,
      "timeStamp": DateTime.now(),
    };

    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    var batch = FirebaseFirestore.instance.batch();
    batch.set(chatCollectionRef.doc(timestamp), messageData);
    batch.set(tutorRecentRef, lastData, SetOptions(merge: true));
    batch.set(studentRecentRef, lastData, SetOptions(merge: true));

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });

    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  void showReportDialog() {
    final teReport = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(24),
            ),
            insetPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            title: Text(
              "รายงานผู้ใช้งาน ${partner.nickname}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            content: TextField(
              controller: teReport,
              decoration: InputDecoration(
                hintText: "ข้อความรายงาน",
              ),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  reportPartner(teReport.text.trim());
                },
                child: Text(
                  "รายงาน",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(COLOR.YELLOW),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side:
                                BorderSide(color: COLOR.YELLOW, width: 2.0)))),
              )
            ],
          );
        });
  }

  Future<void> reportPartner(String text) async {
    Map<String, dynamic> data = {
      "reportByType": Globals.currentUser!.isTutor ? "tutor" : "student",
      "reportByUser": Globals.currentUser!.uid,
      "roomID": widget.roomID,
      "reportMsg": text,
      "timeDate": DateTime.now(),
    };

    String result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.reportUser(partner.uid, data),
        message: Text('Please wait for a moment...'),
      ),
    );

    showToast(result);
  }

  String? checkStopWord(String text) {
    for (var word in wordGroups) {
      if (text.toLowerCase().indexOf(word.toLowerCase()) > -1) {
        return word;
      }
    }

    return null;
  }

  Future<String> createTransaction(double amount) async {
    DateFormat formatter = DateFormat("yyMMddhhmmSSS");
    var dateTimeID = formatter.format(DateTime.now());
    var runID = Globals.currentUser!.uid.substring(0, 2);
    var transactionID = runID + dateTimeID;

    Map<String, dynamic> data = {
      "referenceNo": transactionID,
      "amount": amount,
      "createdBy": Globals.currentUser!.uid,
      "createdDate": DateTime.now(),
      "paidBy": partner.uid,
      "request_id": widget.requestID
    };

    try {
      await FirebaseFirestore.instance
          .collection("TransactionIDs")
          .doc(transactionID)
          .set(data);
      return transactionID;
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  Future<String> createClass(
      String transactionID, Map<String, dynamic> data) async {
    try {
      DocumentReference document =
          await FirebaseFirestore.instance.collection("ClassIDs").add(data);
      String classID = document.id;

      // TUTOR
      Map<String, dynamic> dataTutor = {"student_id": partner.uid};
      DocumentReference tutorRef = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(Globals.currentUser!.uid)
          .collection("Classes")
          .doc(classID);

      // STUDENT
      Map<String, dynamic> dataStudent = {"tutor_id": Globals.currentUser!.uid};
      DocumentReference studentRef = FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(partner.uid)
          .collection("Classes")
          .doc(classID);

      // Transaction
      Map<String, dynamic> dataTransaction = {"class_id": classID};
      DocumentReference transactionRef = FirebaseFirestore.instance
          .collection("TransactionIDs")
          .doc(transactionID);

      var batch = FirebaseFirestore.instance.batch();
      batch.set(transactionRef, dataTransaction, SetOptions(merge: true));
      batch.set(tutorRef, dataTutor);
      batch.set(studentRef, dataStudent);

      await batch.commit().then((value) {}, onError: (e) {
        print(e);
      });

      return classID;
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  Future<void> setClassForUsers(String classID) async {}

  void listenToPaymentQR(String transactionID, Function(Image) callback) {
    transactionSubscription = FirebaseFirestore.instance
        .collection("TransactionIDs")
        .doc(transactionID)
        .snapshots()
        .asBroadcastStream()
        .listen((event) {
      if (event.data() == null) return;

      Map<String, dynamic> data = event.data()!;
      String? qrcode = data["base64qr"] as String?;
      if (qrcode == null || qrcode.isEmpty) return;

      transactionSubscription.cancel();

      callback(imageFromBase64String(qrcode));
    });
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
