import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/profile/privacy_policy.dart';
import 'package:tutor/view/student/profile/terms_condition.dart';
import 'package:tutor/widget/profile_cell.dart';

class InputPage extends StatefulWidget {
  InputPage({Key? key}) : super(key: key);

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  bool _isPrivacy = false;
  bool _isTerm = false;

  final teSchool = TextEditingController();
  final teDegree = TextEditingController();
  final teStudy = TextEditingController();
  final teRate = TextEditingController();
  final teYear = TextEditingController();

  final teBankNumber = TextEditingController();
  final teBankName = TextEditingController();
  final teIDCard = TextEditingController();

  String year = "";

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

  bool _isBankImage = true;
  File? _bankImage, _cardImage;

  final picker = ImagePicker();

  void showImagePicker() async {
    try {
      final XFile? image = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
      if (image != null) {
        setState(() {
          if (_isBankImage) {
            _bankImage = File(image.path);
          } else {
            _cardImage = File(image.path);
          }
        });
      }
    } catch (e) {}

    getLostData();
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.video) {
        } else {
          if (_isBankImage) {
            _bankImage = File(response.file!.path);
          } else {
            _cardImage = File(response.file!.path);
          }
        }
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR.BLUE,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
              "ข้อมูลการศึกษา", //Education
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8, bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: teSchool,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "โรงเรียน/มหาวิทยาลัย",
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teDegree,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "ระดับ/วุฒิ",
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teStudy,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "คณะ",
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teRate,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "เรทสอน (บาท/ชั่วโมง) *ระบุเฉพาะตัวเลข*",
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
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "ประสบการณ์การสอน (ปี) *ระบุเฉพาะตัวเลข*",
                    ),
                    readOnly: true,
                    onTap: () => showYearSheet(context),
                  ),
                ],
              ),
            ),
            Text(
              "ข้อมูลการศึกษา", //Financial
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8, bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: teBankNumber,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "เลขที่ธนาคาร (0294801035)",
                    ),
                  ),
                  Divider(height: 2),
                  TextField(
                    controller: teBankName,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "ชื่อธนาคาร",
                    ),
                  ),
                  Divider(height: 2),
                  //////////////////
                  ///Bank Image
                  //////////////////
                  InkWell(
                    onTap: () {
                      _isBankImage = true;
                      showImagePicker();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "อัพโหลดสำเนาสมุดธนาคาร",
                        style: TextStyle(
                          fontSize: 16,
                          color: COLOR.YELLOW,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "สำเนาสมุดธนาคาร (เซ็นสำเนาถูกต้อง)",
                      style: TextStyle(
                        fontSize: 16,
                        color: COLOR.DARK_GREY,
                      ),
                    ),
                  ),
                  (_bankImage == null)
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_bankImage!),
                                fit: BoxFit.cover),
                          ),
                        ),
                  Divider(height: 2),
                  TextField(
                    controller: teIDCard,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                      hintText: "เลขที่บัตรประชาชน",
                    ),
                  ),
                  Divider(height: 2),
                  //////////////////
                  ///ID Card Image
                  //////////////////
                  InkWell(
                    onTap: () {
                      _isBankImage = false;
                      showImagePicker();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "อัพโหลดสำเนาบัตรประชาชน",
                        style: TextStyle(
                          fontSize: 16,
                          color: COLOR.YELLOW,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "สำเนาบัตรประชาชน (เซ็นสำเนาถูกต้อง)",
                      style: TextStyle(
                        fontSize: 16,
                        color: COLOR.DARK_GREY,
                      ),
                    ),
                  ),
                  (_cardImage == null)
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_cardImage!),
                                fit: BoxFit.cover),
                          ),
                        ),
                ],
              ),
            ),
            Text(
              "ข้อตกลง", //Agreement
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8, bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileCell(
                      title: "นโยบายความเป็นส่วนตัว",
                      titleColor: COLOR.YELLOW,
                      callback: () {
                        //Privacy policy
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => PrivacyPolicy(type: "tutor"),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ยอมรับ นโยบายความเป็นส่วนตัว",
                          style: TextStyle(fontSize: 16),
                        ),
                        CupertinoSwitch(
                            value: _isPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _isPrivacy = value;
                              });
                            })
                      ],
                    ),
                    Divider(),
                    ProfileCell(
                      title: "เงื่อนไขการใช้งาน",
                      titleColor: COLOR.YELLOW,
                      callback: () {
                        //Terms and Condition
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => TermsCondition(type: "tutor"),
                          ),
                        );
                      },
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ยอมรับ เงื่อนไขการใช้งาน",
                          style: TextStyle(fontSize: 16),
                        ),
                        CupertinoSwitch(
                            value: _isTerm,
                            onChanged: (value) {
                              setState(() {
                                _isTerm = value;
                              });
                            })
                      ],
                    )
                  ]),
            ),
            ElevatedButton(
              onPressed: () {
                //Save
                setTutorProfile();
              },
              child: Text(
                "บันทึกข้อมูล",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                primary: Colors.white,
                onPrimary: COLOR.YELLOW,
                minimumSize: Size(MediaQuery.of(context).size.width, 40),
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

  void setTutorProfile() async {
    FocusScope.of(context).unfocus();

    String school = teSchool.text.trim();
    String degree = teDegree.text.trim();
    String study = teStudy.text.trim();
    String rate = teRate.text.trim();
    
    String bankNumber = teBankNumber.text.trim();
    String bankName = teBankName.text.trim();
    String idCard = teIDCard.text.trim();

    if (school.isEmpty ||
        degree.isEmpty ||
        study.isEmpty ||
        rate.isEmpty ||
        year.isEmpty ||
        bankNumber.isEmpty ||
        bankName.isEmpty ||
        idCard.isEmpty ||
        _bankImage == null ||
        _cardImage == null) {
      showToast("กรุณากรอกข้อมูลให้ครบ");
      return;
    }

    if (!_isPrivacy || !_isTerm) {
      showToast("กรุณายอมรับเงื่อนไขการใช้งานของติวเตอร์");
      return;
    }

    String userID = FirebaseAuth.instance.currentUser!.uid;

    String result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.uploadImage(_bankImage!, "bank"),
        message: Text('Please wait for a moment...'),
      ),
    );

    if (result == "ERROR_UPLOAD_IMAGE") {
      showToast("Upload failed");
    } else {
      String bankImageUrl = result;
      result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.uploadImage(_cardImage!, "id_card"),
          message: Text('Please wait for a moment...'),
        ),
      );

      if (result == "ERROR_UPLOAD_IMAGE") {
        showToast("Upload failed");
      } else {
        String cardImageUrl = result;
        await Util.setNewTutor(userID, school, degree, study, rate, year,
            bankNumber, bankName, idCard, bankImageUrl, cardImageUrl);

        await FirebaseAuth.instance.currentUser!.sendEmailVerification().then(
            (value) async {
          await FirebaseAuth.instance.signOut();
          showToast("เราได้ส่งการยืนยันอีเมลไปที่อีเมลของคุณ กรุณายืนยันอีเมล");

          showResult(context, "เราได้รับเอกสารของคุณแล้ว",
              "กรุณารอผลการตรวจสอบเอกสารและเราจะแจ้งผลการสมัครกลับไปผ่านอีเมลที่คุณกรอก",
              () {
            Navigator.of(context).pop();
          });
        }, onError: (e) {
          showToast(e);
        });
      }
    }
  }

  void showResult(BuildContext context, String title, String description,
      VoidCallback callback) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        content: Text(
          description,
          style: TextStyle(fontSize: 11),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              callback();
            },
          )
        ],
      ),
    );
  }
}
