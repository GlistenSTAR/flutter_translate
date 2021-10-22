import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';

class EducationPage extends StatefulWidget {
  EducationPage({Key? key, required this.info}) : super(key: key);

  final Map<String, dynamic> info;

  @override
  _EducationPageState createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  late Map<String, dynamic> info;

  final teSchool = TextEditingController();
  final teDegree = TextEditingController();
  final teStudy = TextEditingController();
  final teRate = TextEditingController();
  final teYear = TextEditingController();

  late String year;

  List<String> years = [
    "น้อยกว่า 1",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "มากกว่า 10"
  ];

  @override
  void initState() {
    super.initState();

    info = widget.info;
    teSchool.text = info["school"] ?? "";
    teDegree.text = info["degree"] ?? "";
    teStudy.text = info["field_of_study"] ?? "";
    teRate.text = info["rate"] ?? "";
    year = info["teaching_exp_year"] ?? "";
    teYear.text = year == "" ? "" : year + " ปี";
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
              "แก้ไขประวัติการศึกษา",
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
                    controller: teSchool,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "โรงเรียน/มหาวิทยาลัย",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teDegree,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "ระดับ",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teStudy,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "คณะ",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teRate,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "เรทสอน (บาท/ชั่วโมง) *ระบุเฉพาะตัวเลข*",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teYear,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "ประสบการณ์การสอน (ปี) *ระบุเฉพาะตัวเลข*",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                    readOnly: true,
                    onTap: () => showYearSheet(context),
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
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showYearSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("เลือก"),
        actions: years
            .map<CupertinoActionSheetAction>((e) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    year = e;
                    teYear.text = year + " ปี";
                  },
                  child: Text(e + " ปี"),
                ))
            .toList(),
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
    String school = teSchool.text.trim();
    String degree = teDegree.text.trim();
    String study = teStudy.text.trim();
    String rate = teRate.text.trim();

    Map<String, dynamic> display = {
      "school": school,
      "degree": degree,
      "field_of_study": study,
      "rate": rate,
      "teaching_exp_year": year
    };

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.updateEducation(Globals.currentUser!.uid, display, display),
        message: Text('Please wait for a moment...'),
      ),
    );

    Navigator.of(context).pop(display);
  }
}
