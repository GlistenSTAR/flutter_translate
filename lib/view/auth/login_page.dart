import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/auth/reset_page.dart';
import 'package:tutor/view/auth/signup_page.dart';
import 'package:tutor/view/student/main_student.dart';
import 'package:tutor/view/tutor/main_tutor.dart';
import 'package:tutor/view/tutor/register/input_page.dart';
import 'package:tutor/view/tutor/register/quiz_page.dart';
import 'package:tutor/widget/entry_field.dart';
import 'package:tutor/model/user.dart' as AppUser;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController teEmail = TextEditingController();
  final TextEditingController tePassword = TextEditingController();

  late bool isTutor;

  @override
  void initState() {
    super.initState();
    isTutor = false;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR.BLUE,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("images/common/logo.png", width: 118, height: 118),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Student
                InkWell(
                  onTap: () {
                    setState(() {
                      isTutor = false;
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 43,
                        foregroundImage:
                            AssetImage("images/common/student.png"),
                        // child: Image.asset("images/common/student.png"),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "นักเรียน",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.bold,
                          color: isTutor ? Colors.white : COLOR.YELLOW,
                          fontSize: 20,
                          letterSpacing: 0.38,
                        ),
                      ),
                    ],
                  ),
                ),
                //Tutor
                InkWell(
                  onTap: () {
                    setState(() {
                      isTutor = true;
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 43,
                        foregroundImage: AssetImage("images/common/tutor.png"),
                        // child: Image.asset("images/common/tutor.png"),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ติวเตอร์",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.bold,
                          color: isTutor ? COLOR.YELLOW : Colors.white,
                          fontSize: 20,
                          letterSpacing: 0.38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  EntryField(
                    controller: teEmail,
                    icon: Icons.person_outline,
                    hint: "อีเมล",
                  ),
                  SizedBox(height: 16),
                  EntryField(
                    controller: tePassword,
                    icon: Icons.lock_outline,
                    hint: "รหัสผ่าน",
                    isPassword: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        //forgot password?
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ResetPage(),
                          ),
                        );
                      },
                      child: Text(
                        "ลืมรหัสผ่าน?",
                        style: TextStyle(
                          color: COLOR.YELLOW,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.38,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: Text(
                      "เข้าใช้งาน",
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: COLOR.YELLOW,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.38,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 48),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "ยังไม่มีแอคเคาท์?   ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    letterSpacing: 0.38,
                  ),
                  children: [
                    TextSpan(
                      text: "ลงทะเบียน",
                      style: TextStyle(color: COLOR.YELLOW),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //Sign up
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignupPage(isTutor: isTutor),
                            ),
                          );
                        },
                    ),
                  ]),
            ),
          ],
        ),
      )),
    );
  }

  void login(BuildContext context) async {
    FocusScope.of(context).unfocus();

    String email = teEmail.text.trim();
    String password = tePassword.text;

    if (email.isEmpty || password.isEmpty) {
      showToast("กรุณากรอกอีเมลและรหัสผ่าน");
      return;
    }

    dynamic result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.login(email, password),
        message: Text('Please wait for a moment...'),
      ),
    );

    if (result is Map<String, dynamic>) {
      _checkRole(result);
    } else {
      showToast(result);
    }
  }

  void autoLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      dynamic result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.getUserInfo(FirebaseAuth.instance.currentUser!.uid),
          message: Text('Please wait for a moment...'),
        ),
      );

      if (result is Map<String, dynamic>) {
        _checkRole(result);
      } else {
        await FirebaseAuth.instance.signOut();
      }
    }
  }

  void _checkRole(Map<String, dynamic> data) async {
    if (data["isRequesting"] == null && data["isTutor"] != true) {
      //Student
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        showToast("กรุณายืนยันอีเมล");
        FirebaseAuth.instance.signOut();
        return;
      }

      await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.saveDeviceToken(FirebaseAuth.instance.currentUser!.uid),
          message: Text('Please wait for a moment...'),
        ),
      );

      dynamic result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(
          Util.getStudent(FirebaseAuth.instance.currentUser!.uid),
          message: Text('Please wait for a moment...'),
        ),
      );

      if (result is Map<String, dynamic>) {
        Globals.currentUser = AppUser.User(
          uid: FirebaseAuth.instance.currentUser!.uid,
          isTutor: false,
          nickname: result["nickname"] ?? "",
          name: result["name"] ?? "",
          profileUrl: result["display_img"] ?? "",
          address: result["address"] ?? "",
          idCard: result["id_card_filled"] ?? "",
          following: (result["following"] == null)
              ? []
              : (result["following"] as List)
                  .map<String>((e) => e.toString())
                  .toList(),
        );
      } else {
        Globals.currentUser = AppUser.User(
          uid: FirebaseAuth.instance.currentUser!.uid,
          isTutor: false,
          nickname: "",
          name: "",
          address: "",
          profileUrl: "",
          idCard: "",
          following: [],
        );
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainStudent()),
      );
    } else {
      //Tutor
      if (data["isTutor"] == true) {
        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
          showToast("กรุณายืนยันอีเมล");
          FirebaseAuth.instance.signOut();
          return;
        }

        await showDialog(
          context: context,
          builder: (context) => FutureProgressDialog(
            Util.saveDeviceToken(FirebaseAuth.instance.currentUser!.uid),
            message: Text('Please wait for a moment...'),
          ),
        );

        dynamic result = await showDialog(
          context: context,
          builder: (context) => FutureProgressDialog(
            Util.getTutor(FirebaseAuth.instance.currentUser!.uid),
            message: Text('Please wait for a moment...'),
          ),
        );

        if (result is Map<String, dynamic>) {
          Globals.currentUser = AppUser.User(
            uid: FirebaseAuth.instance.currentUser!.uid,
            isTutor: true,
            nickname: result["nickname"] ?? "",
            name: result["name"] ?? "",
            profileUrl: result["display_img"] ?? "",
            address: result["address"] ?? "",
            idCard: result["id_card_filled"] ?? "",
            following: (result["following"] == null)
                ? []
                : (result["following"] as List)
                    .map<String>((e) => e.toString())
                    .toList(),
          );
        } else {
          Globals.currentUser = AppUser.User(
            uid: FirebaseAuth.instance.currentUser!.uid,
            isTutor: true,
            nickname: "",
            name: "",
            profileUrl: "",
            address: "",
            idCard: "",
            following: [],
          );
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainTutor()),
        );
      } else {
        if (data["testPass"] == true) {
          dynamic result = await showDialog(
            context: context,
            builder: (context) => FutureProgressDialog(
              Util.getTutor(FirebaseAuth.instance.currentUser!.uid),
              message: Text('Please wait for a moment...'),
            ),
          );

          if (result is Map && result["degree"] != null) {
            if (!FirebaseAuth.instance.currentUser!.emailVerified) {
              showToast("กรุณายืนยันอีเมล");
              FirebaseAuth.instance.signOut();
              return;
            }
            //Not need to do anything
            showToast("Please wait administrator allow your totur account");
          } else {
            //Empty Tutor Info
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InputPage()),
            );
          }
        } else {
          //Need to test
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => QuizPage()),
          );
        }
      }
    }
  }
}
