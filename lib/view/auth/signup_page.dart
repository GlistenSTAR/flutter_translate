import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/StringsModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/profile/privacy_policy.dart';
import 'package:tutor/view/student/profile/terms_condition.dart';
import 'package:tutor/view/student/schedule/calendar_page.dart';
import 'package:tutor/view/tutor/register/quiz_page.dart';
import 'package:tutor/widget/choose_string.dart';
import 'package:tutor/widget/profile_cell.dart';
import 'package:tutor/widget/select_string.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key, required this.isTutor}) : super(key: key);

  final bool isTutor;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late bool isTutor;

  final TextEditingController teEmail = TextEditingController();
  final TextEditingController tePassword = TextEditingController();
  final TextEditingController teConfirm = TextEditingController();

  final TextEditingController teName = TextEditingController();
  final TextEditingController teNickname = TextEditingController();
  final TextEditingController teGender = TextEditingController();
  final TextEditingController teBirthday = TextEditingController();
  final TextEditingController teGrade = TextEditingController();
  final TextEditingController teSchool = TextEditingController();

  final TextEditingController tePhone = TextEditingController();
  final TextEditingController teLineID = TextEditingController();
  final TextEditingController teAddress = TextEditingController();

  late StringsModel selectedString = StringsModel(stringID: "", stringTH: "");

  bool agreeToPolicy = false, agreeToTerm = false;

  @override
  void initState() {
    super.initState();
    isTutor = widget.isTutor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR.BLUE,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isTutor ? "ลงทะเบียนและสมัครติวเตอร์" : "ลงทะเบียน",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "แอคเคาท์",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: teEmail,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "อีเมล(Email)*",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Divider(height: 4),
                    TextField(
                      controller: tePassword,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "รหัสผ่าน(Password)*",
                      ),
                      obscureText: true,
                    ),
                    Divider(height: 4),
                    TextField(
                      controller: teConfirm,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "ยืนยันรหัสผ่าน(Re-Password)*",
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ช้อมูลส่วนตัว",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: teName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "ชื่อ(Name)*",
                      ),
                    ),
                    Divider(height: 4),
                    TextField(
                      controller: teNickname,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "ชื่อเล่น(Nickname)",
                      ),
                    ),
                    Divider(height: 4),
                    // TextField(
                    //   controller: teGender,
                    //   readOnly: true,
                    //   onTap: () => showGenderSheet(context),
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    //     hintText: "เพศ(Gender)",
                    //   ),
                    // ),
                    ChooseString(
                      placeholder: "เพศ",
                      selected: selectedString,
                      callback: () async {
                        dynamic result = await Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            barrierColor: Colors.black54,
                            pageBuilder: (_, __, ___) => SelectString(
                              title: "เลือกเพศ",
                              selected: selectedString,
                              models: StringsModel.getGenders(),
                            ),
                          ),
                        );

                        if (result != null && result is StringsModel) {
                          setState(() {
                            selectedString = result;
                          });
                        }
                      },
                    ),
                    Divider(height: 4),
                    TextField(
                      controller: teBirthday,
                      readOnly: true,
                      onTap: () async {
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
                          teBirthday.text = Util.getBuddhistDate(result);
                        }
                      },
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "วันเกิด(Birthday)",
                      ),
                    ),
                    isTutor
                        ? Container()
                        : Column(
                            children: [
                              Divider(height: 4),
                              TextField(
                                controller: teGrade,
                                readOnly: true,
                                onTap: () => showGradeSheet(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: COLOR.DARK_GREY),
                                  hintText: "ระดับชั้น(Grade)",
                                ),
                              ),
                              Divider(height: 4),
                              TextField(
                                controller: teSchool,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: COLOR.DARK_GREY),
                                  hintText: "สถานศึกษา(School)",
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "ข้อมูลการติดต่อ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: tePhone,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "เบอร์โทร*",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    Divider(height: 4),
                    TextField(
                      controller: teLineID,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "Line ID",
                      ),
                    ),
                    Divider(height: 4),
                    TextField(
                      controller: teAddress,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: COLOR.DARK_GREY),
                        hintText: "ที่อยู่",
                      ),
                    ),
                  ],
                ),
              ),
              isTutor ? Container() : _agreeWidget(context),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  signup(context);
                  // if (isTutor) {
                  //   //Need to test
                  //   Navigator.of(context).pushReplacement(
                  //     CupertinoPageRoute(
                  //       builder: (context) => QuizPage(),
                  //     ),
                  //   );
                  // } else {
                  //   //Sign up
                  //   //Please confirm your identity in your email.
                  //   showCupertinoDialog(
                  //     context: context,
                  //     builder: (context) => CupertinoAlertDialog(
                  //       content: Text(
                  //         "กรุณากดยืนยันตัวตนในอีเมลของคุณ",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //       ),
                  //       actions: [
                  //         CupertinoDialogAction(
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: Text("OK"),
                  //         )
                  //       ],
                  //     ),
                  //   );
                  // }
                },
                child: Text(
                  isTutor ? "ทำแบบทดสอบ" : "ลงทะเบียน",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    color: COLOR.YELLOW,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 48),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _agreeWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "ข้อตกลง",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            children: [
              ProfileCell(
                title: "นโยบายความเป็นส่วนตัว",
                titleColor: COLOR.YELLOW,
                callback: () {
                  //Privacy policy
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => PrivacyPolicy(type: "student"),
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
                      value: agreeToPolicy,
                      onChanged: (v) {
                        setState(() {
                          agreeToPolicy = v;
                        });
                      }),
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
                      builder: (context) => TermsCondition(type: "student"),
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
                      value: agreeToTerm,
                      onChanged: (v) {
                        setState(() {
                          agreeToTerm = v;
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
      ],
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

  void showGradeSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("ระดับชั้น"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              teGrade.text = "ประถม";
              Navigator.of(context).pop();
            },
            child: Text("ประถม"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              teGrade.text = "มัธยมต้น";
              Navigator.of(context).pop();
            },
            child: Text("มัธยมต้น"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              teGrade.text = "มัธยมปลาย";
              Navigator.of(context).pop();
            },
            child: Text("มัธยมปลาย"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              teGrade.text = "มหาลัย";
              Navigator.of(context).pop();
            },
            child: Text("มหาลัย"),
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

  void signup(BuildContext context) async {
    FocusScope.of(context).unfocus();

    String email = teEmail.text.trim();
    String password = tePassword.text;
    String cpassword = teConfirm.text;
    String name = teName.text;
    String nickname = teNickname.text;
    String gender = selectedString.stringTH;
    String birthday = teBirthday.text;
    String phone = tePhone.text;
    String lineID = teLineID.text;
    String address = teAddress.text;
    String grade = teGrade.text;
    String school = teSchool.text;

    //Grade
    grade = Util.gradeID(grade);

    //Gender
    gender = Util.genderID(gender);

    if (email.isEmpty ||
        password.isEmpty ||
        cpassword.isEmpty ||
        name.isEmpty ||
        phone.isEmpty) {
      showToast("กรุณากรอกอีเมลและรหัสผ่าน");
      return;
    }

    if (!isTutor && (agreeToPolicy == false || agreeToTerm == false)) {
      showToast("กรุณายอมรับเงื่อนไขการใช้แอป");
      return;
    }

    if (isTutor &&
        (nickname.isEmpty ||
            birthday.isEmpty ||
            gender.isEmpty ||
            address.isEmpty ||
            lineID.isEmpty ||
            phone.isEmpty)) {
      showToast("กรุณากรอกข้อมูลให้ครบ");
      return;
    }

    if (password != cpassword) {
      showToast("รหัสผ่านไม่ตรงกัน");
      return;
    }

    String result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.signup(email, password),
        message: Text('Please wait for a moment...'),
      ),
    );

    if (result == "Success") {
      if (isTutor) {
        await showDialog(
          context: context,
          builder: (context) => FutureProgressDialog(
            Util.saveUserInfo(
                FirebaseAuth.instance.currentUser!.uid,
                email,
                name,
                gender,
                grade,
                school,
                phone,
                lineID,
                address,
                agreeToPolicy,
                agreeToTerm,
                nickname,
                birthday,
                true),
            message: Text('Please wait for a moment...'),
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => QuizPage()),
        );
      } else {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification().then(
            (value) async {
          await showDialog(
            context: context,
            builder: (context) => FutureProgressDialog(
              Util.saveUserInfo(
                  FirebaseAuth.instance.currentUser!.uid,
                  email,
                  name,
                  gender,
                  grade,
                  school,
                  phone,
                  lineID,
                  address,
                  agreeToPolicy,
                  agreeToTerm,
                  nickname,
                  birthday,
                  false),
              message: Text('Please wait for a moment...'),
            ),
          );
          await FirebaseAuth.instance.signOut();
          showToast("เราได้ส่งการยืนยันอีเมลไปที่อีเมลของคุณ กรุณายืนยันอีเมล");
          Navigator.of(context).pop();
        }, onError: (e) {
          showToast(e);
        });
      }
    } else {
      showToast(result);
    }
  }
}
