import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/auth/login_page.dart';
import 'package:tutor/view/student/profile/contact_info.dart';
import 'package:tutor/view/student/profile/contact_us.dart';
import 'package:tutor/view/student/profile/personal_info.dart';
import 'package:tutor/view/student/profile/privacy_policy.dart';
import 'package:tutor/view/student/profile/terms_condition.dart';
import 'package:tutor/view/tutor/profile/class_page.dart';
import 'package:tutor/view/tutor/profile/education_page.dart';
import 'package:tutor/view/tutor/profile/promote_page.dart';
import 'package:tutor/view/tutor/profile/teach_location.dart';
import 'package:tutor/view/tutor/profile/teach_subject.dart';
import 'package:tutor/view/tutor/profile/teach_test.dart';
import 'package:tutor/widget/profile_cell.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic> tutor = {};
  Map<String, dynamic>? teaching;

  File? _profileImage;

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (tutor.isEmpty) {
      return FutureBuilder(
          future: Util.getTutor(Globals.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              tutor = snapshot.data as Map<String, dynamic>;
              return _profileWidget();
            } else if (snapshot.hasError) {
              return Center(child: Text("Connection Error"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    } else {
      return _profileWidget();
    }
  }

  void showImagePicker() async {
    try {
      final XFile? image = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
      if (image != null) {
        _profileImage = File(image.path);
        updateProfile();
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
      if (response.type == RetrieveType.video) {
      } else {
        _profileImage = File(response.file!.path);
        updateProfile();
      }
    } else {}
  }

  Widget _profileWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: COLOR.LIGHT_GREY,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            tutor["display_img"] == null
                ? Image.asset(
                    "images/common/logo.png",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )
                : Container(
                    width: 100,
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: tutor["display_img"],
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
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
            TextButton(
              onPressed: () {
                showImagePicker();
              },
              child: Text(
                "แก้ไขรูป",
                style: TextStyle(color: COLOR.YELLOW),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ข้อมูลส่วนตัว",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: COLOR.DARK_GREY,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutor["nickname"],
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  Text(
                    tutor["name"], //"ชื่อ"
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  ProfileCell(
                    title: "แก้ไขข้อมูล",
                    callback: () async {
                      //Edit profile
                      dynamic result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => PersonalInfo(
                            isTutor: true,
                            info: tutor,
                          ),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          tutor.addAll(result);
                        });

                        Globals.currentUser!.name = result["name"];
                        Globals.currentUser!.nickname = result["nickname"];
                        Globals.currentUser!.address = result["address"];
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "MY CLASS", //Study
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: COLOR.DARK_GREY,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCell(
                    title: "คลาสของฉัน",
                    titleColor: Colors.black,
                    callback: () {
                      //My class
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) {
                            return ClassPage();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ////////////////////
            ///Teaching Information
            ////////////////////
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ข้อมูลทางการสอน",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: COLOR.DARK_GREY,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCell(
                    title: "ประวัติการศึกษาและเรท",
                    titleColor: Colors.black,
                    callback: () {
                      //EdBGView
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => EducationPage(info: tutor),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "ประวัติการสอนเพิ่มเติม",
                    titleColor: Colors.black,
                    callback: () async {
                      //EditPromoteTextView
                      dynamic result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => PromotePage(info: tutor),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          tutor.addAll(result);
                        });
                      }
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "สถานที่สอน",
                    titleColor: Colors.black,
                    callback: () async {
                      //TeachLocationView
                      if (teaching == null) {
                        dynamic result = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Util.getTutor(Globals.currentUser!.uid,
                                type: "Teaching"),
                            message: Text('Please wait for a moment...'),
                          ),
                        );

                        if (result is Map<String, dynamic>) {
                          teaching = result;
                        } else {
                          teaching = {};
                        }
                      }

                      dynamic result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TeachLocation(info: teaching!),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        teaching!.addAll(result);
                      }
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "วิชา/ระดับชั้นที่สอน",
                    titleColor: Colors.black,
                    callback: () async {
                      //TeachSubjectView2
                      if (teaching == null) {
                        dynamic result = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Util.getTutor(Globals.currentUser!.uid,
                                type: "Teaching"),
                            message: Text('Please wait for a moment...'),
                          ),
                        );

                        if (result is Map<String, dynamic>) {
                          teaching = result;
                        } else {
                          teaching = {};
                        }
                      }

                      dynamic result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TeachSubject(info: teaching!),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        teaching!.addAll(result);
                      }
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "ติวสอบที่สอน",
                    titleColor: Colors.black,
                    callback: () async {
                      //TeachTestingVIew
                      if (teaching == null) {
                        dynamic result = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            Util.getTutor(Globals.currentUser!.uid,
                                type: "Teaching"),
                            message: Text('Please wait for a moment...'),
                          ),
                        );

                        if (result is Map<String, dynamic>) {
                          teaching = result;
                        } else {
                          teaching = {};
                        }
                      }

                      dynamic result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TeachTest(info: teaching!),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        teaching!.addAll(result);
                      }
                    },
                  ),
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
                  color: COLOR.DARK_GREY,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutor["email"] ?? "",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  Text(
                    tutor["tel"] ?? "",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  Text(
                    tutor["line_id"] ?? "",
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  ProfileCell(
                    title: "แก้ไขข้อมูล",
                    callback: () async {
                      //Contact information
                      dynamic result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ContactInfo(
                            isTutor: true,
                            info: tutor,
                          ),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        tutor.addAll(result);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "อื่นๆ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: COLOR.DARK_GREY,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCell(
                    title: "คู่มือการใช้งาน",
                    titleColor: Colors.black,
                    callback: () {
                      //User manual
                      launch(
                          "https://drive.google.com/file/d/1Q073dcM5ECXtt1JTcznmSnKayJEGYCMo/view");
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "เงื่อนไขการใช้งานแอปทั่วไป",
                    titleColor: Colors.black,
                    callback: () {
                      //Terms and Condition ::: Student
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TermsCondition(type: "student"),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "เงื่อนไขการใช้งานของติวเตอร์",
                    titleColor: Colors.black,
                    callback: () {
                      //Terms and Condition ::: Tutor
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TermsCondition(type: "tutor"),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ProfileCell(
                    title: "นโยบายความเป็นส่วนตัว",
                    titleColor: Colors.black,
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
                  ProfileCell(
                    title: "ติดต่อเรา",
                    titleColor: Colors.black,
                    callback: () {
                      //Contact us
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) =>
                              ContactUs(email: "tutor.haus.partners@gmail.com"),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  InkWell(
                    onTap: () async {
                      //Log Out
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "ลงชื่อออก",
                      style: TextStyle(fontSize: 16, color: COLOR.YELLOW),
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

  void updateProfile() async {
    String result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.uploadImage(_profileImage!, "profile"),
        message: Text('Please wait for a moment...'),
      ),
    );

    if (result == "ERROR_UPLOAD_IMAGE") {
      showToast("Upload Failed");
      return;
    }

    Map<String, dynamic> data = {"display_img": result};

    await FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(Globals.currentUser!.uid)
        .collection("Information")
        .doc("Display")
        .set(data, SetOptions(merge: true));

    setState(() {
      tutor["display_img"] = result;
    });
  }
}
