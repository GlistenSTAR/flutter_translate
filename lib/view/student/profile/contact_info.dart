import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';

class ContactInfo extends StatefulWidget {
  ContactInfo({Key? key, required this.isTutor, required this.info})
      : super(key: key);

  final bool isTutor;
  final Map<String, dynamic> info;

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  late bool isTutor;
  late Map<String, dynamic> info;

  final teEmail = TextEditingController();
  final tePhone = TextEditingController();
  final teLineID = TextEditingController();

  @override
  void initState() {
    super.initState();
    isTutor = widget.isTutor;
    info = widget.info;

    teEmail.text = info["email"];
    tePhone.text = info["tel"] ?? "";
    teLineID.text = info["line_id"];
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "แก้ไขข้อมูลติดต่อ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: teEmail,
                    enabled: false,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "อีเมล*",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: tePhone,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "เบอร์โทร*",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teLineID,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Line ID",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  TextButton(
                    onPressed: () {
                      updateContact(context);
                    },
                    child: Text(
                      "บันทึกข้อมูล",
                      style: TextStyle(
                        color: COLOR.YELLOW,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateContact(BuildContext context) async {
    FocusScope.of(context).unfocus();

    String tel = tePhone.text.trim();
    String lineID = teLineID.text.trim();

    if (tel.isEmpty) {
      showToast("กรุณากรอกข้อมูลให้ครบ");
      return;
    }

    if (info["tel"] == tel && lineID == info["line_id"]) {
      //Not need to update anything.
      Navigator.of(context).pop();
    } else {
      Map<String, dynamic> contact = {
        "tel": tel,
        "line_id": lineID,
      };

      await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.updateContact(
              isTutor, Globals.currentUser!.uid, contact),
          message: Text('Please wait for a moment...'),
        ),
      );

      Navigator.of(context).pop(contact);
    }
  }
}
