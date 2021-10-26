import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/utils/const.dart';

class TutorRating extends StatefulWidget {
  TutorRating({Key? key, required this.model}) : super(key: key);

  final ClassModel model;

  @override
  _TutorRatingState createState() => _TutorRatingState();
}

class _TutorRatingState extends State<TutorRating> {
  final teReview = TextEditingController();
  double _rating = 1;
  List<String> _types = [
    "ควรปรับปรุงการสอน",
    "สอนพอใช้",
    "สอนดี",
    "สอนดีมาก",
    "สอนยอดเยี่ยม"
  ];

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
              "รีวิวและให้คะแนนติวเตอร์",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Prompt',
                letterSpacing: 0.12,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: COLOR.LIGHT_GREY),
                        image: DecorationImage(
                          image: AssetImage("images/subject/icon-art.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.model.tutorNickname,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Prompt',
                        letterSpacing: 0.12,
                      ),
                    ),
                    SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: 1.0,
                      minRating: 1,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: COLOR.YELLOW,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                      updateOnDrag: true,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _rating >= 1 ? _types[(_rating - 1).toInt()] : "",
                      style: TextStyle(fontSize: 18, fontFamily: 'Prompt'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: COLOR.TEXT_BORDER),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 1,
                          )
                        ],
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: teReview,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              "แสดงความคิดเห็นเพิ่มเติมในการสอนของติวเตอร์",
                          hintStyle: TextStyle(
                            color: COLOR.TEXT_HINT,
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            fontFamily: 'Prompt',
                            letterSpacing: 0.12,
                          ),
                        ),
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 300,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        String result = await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            writeReview(),
                          ),
                        );

                        if (result == "Success") {
                          Navigator.of(context).pop();
                        } else {
                          showToast("Connection Error");
                        }
                      },
                      child: Text(
                        "ยืนยัน",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Prompt',
                          letterSpacing: 0.12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 30),
                        primary: COLOR.BLUE,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> writeReview() async {
    try {
      Map<String, dynamic> review = {
        "tutor_rating": _rating,
        "tutor_review": teReview.text.trim(),
      };
      await FirebaseFirestore.instance
          .collection("ClassIDs")
          .doc(widget.model.id)
          .set(review, SetOptions(merge: true));
      return "Success";
    } catch (e) {
      return "Error";
    }
  }
}
