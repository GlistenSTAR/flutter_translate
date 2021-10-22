import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/schedule/calendar_page.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key? key, required this.isTutor, required this.info})
      : super(key: key);

  final bool isTutor;
  final Map<String, dynamic> info;

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late Map<String, dynamic> info;

  final teNickname = TextEditingController();
  final teName = TextEditingController();
  final teGender = TextEditingController();
  final teAddress = TextEditingController();

  late DateTime birthday;

  @override
  void initState() {
    super.initState();

    info = widget.info;
    teNickname.text = info["nickname"] ?? "";
    teName.text = info["name"] ?? "";
    birthday = Util.getDateFromBuddhist(info["birthday"] ?? "");
    teGender.text = Util.genderTH(info["gender"] ?? "");
    teAddress.text = info["address"] ?? "";
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
              "แก้ไขข้อมูลส่วนตัว",
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
                    controller: teNickname,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "ชื่อเล่น*",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teName,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "ชื่อ*",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("วันเกิด"),
                        ElevatedButton(
                          onPressed: () async {
                            //Need to show date picker
                            dynamic result = await Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.black54,
                                pageBuilder: (_, __, ___) => CalendarPage(
                                  date: DateTime(2000),
                                ),
                              ),
                            );

                            if (result != null && result is DateTime) {
                              setState(() {
                                birthday = result;
                              });
                            }
                          },
                          child: Text(Util.formatedStringFrom(birthday)),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFEEEEEF),
                            onPrimary: COLOR.YELLOW,
                          ),
                        ),
                      ]),
                  Divider(height: 2),
                  TextField(
                    controller: teGender,
                    readOnly: true,
                    onTap: () => showGenderSheet(context),
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "เพศ",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teAddress,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "ที่อยู่",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  TextButton(
                    onPressed: () {
                      updateInfo();
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

  void showGenderSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("เลือกเพศ"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              teGender.text = "หญิง";
              Navigator.of(context).pop();
            },
            child: Text("หญิง"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              teGender.text = "ชาย";
              Navigator.of(context).pop();
            },
            child: Text("ชาย"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              teGender.text = "เพศทางเลือก";
              Navigator.of(context).pop();
            },
            child: Text("เพศทางเลือก"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('ปิด'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
  
  void updateInfo() async {
    String nickname = teNickname.text.trim();
    String name = teName.text.trim();
    String birth = Util.getBuddhistDate(birthday);
    String gender = teGender.text.trim();
    String address = teAddress.text.trim();

    if (name.isEmpty) {
      showToast("Please input your name");
      return;
    }

    gender = Util.genderID(gender);

    Map<String, dynamic> display = {"name": name, "nickname": nickname};

    Map<String, dynamic> personal = {
      "address": address,
      "birthday": birth,
      "gender": gender,
    };

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.updateInfo(widget.isTutor, Globals.currentUser!.uid,
            display, personal),
        message: Text('Please wait for a moment...'),
      ),
    );

    display.addAll(personal);

    Navigator.of(context).pop(display);
  }
}
