import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor/model/QuizModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/tutor/register/input_page.dart';
import 'package:tutor/widget/quiz_section.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentReference quizRef =
        FirebaseFirestore.instance.collection("Application").doc("TutorQuiz");

    List<bool?> answers = [];

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
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Text(
                "กรุณาอ่านระเบียบข้อบังคับด้านล่างนี้และตอบคำถามทั้งหมด 10 ข้อ \n\n*ติวเตอร์จะต้องได้อย่างน้อย 8  คะแนน (คะแนนเต็ม 10 คะแนน)*",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: FutureBuilder<DocumentSnapshot>(
                  future: quizRef.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      String info = data["Info"] ?? "";
                      return Text(
                        info.replaceAll("\\n", "\n"),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Connection Error");
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            FutureBuilder<QuerySnapshot>(
              future: quizRef.collection("Live").get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Object?>> docs =
                      snapshot.data!.docs;
                  List<QuizModel> models = docs.map<QuizModel>((e) {
                    Map<String, dynamic> data =
                        e.data() as Map<String, dynamic>;
                    return QuizModel.fromJson(data);
                  }).toList();

                  answers = List.generate(models.length, (index) => null);

                  return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        return QuizSection(
                          quizModel: models[index],
                          onSelected: (v) {
                            answers.removeAt(index);
                            answers.insert(index, v);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 16),
                      itemCount: models.length);
                } else if (snapshot.hasError) {
                  return Text("Connection Error");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (answers.length == 0) {
                  print("There is no questions and answers");
                  return;
                }

                print(FirebaseAuth.instance.currentUser!.uid);

                int noCount =
                    answers.where((element) => element == null).toList().length;
                if (noCount > 0) {
                  showToast("กรุณาตอบให้ครบทุกคำถาม");
                  return;
                }

                if (FirebaseAuth.instance.currentUser == null) {
                  showResult(context, "คุณยังไม่ได้ลงทะเบียน",
                      "กรุณาลงทะเบียนใช้งาน", () {});
                  return;
                }

                int point =
                    answers.where((element) => element == true).toList().length;
                DocumentReference userRef = FirebaseFirestore.instance
                    .collection("StudentIDs")
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                Map<String, dynamic> data = {
                  "doneTest": true,
                  "testDate": Util.getBuddhistDate(DateTime.now()),
                };

                // #####
                point = 10;

                if (point > 7) {
                  data["testPass"] = true;
                  await userRef.set(data, SetOptions(merge: true));
                  showResult(
                      context, "คุณสอบผ่านการทดสอบ", "คุณได้คะแนน $point", () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => InputPage()),
                    );
                  });
                } else {
                  data["testPass"] = false;
                  await userRef.set(data, SetOptions(merge: true));
                  showResult(context, "คุณไม่ผ่านการทดสอบ",
                      "คุณไม่ผ่านแบบทดสอบ คุณได้คะแนน $point คะแนน, แต่สามารถสมัครเข้ามาใหม่ได้ในอีก 30 วันค่ะ",
                      () {
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text(
                "ส่งคำตอบ",
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

  void showResult(BuildContext context, String title, String description,
      VoidCallback callback) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Prompt',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.12,
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black45,
              ),
            ),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 14,
              letterSpacing: 0.12,
            ),
          ),
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
