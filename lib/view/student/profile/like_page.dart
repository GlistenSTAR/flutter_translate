import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/search/tutor_page.dart';
import 'package:tutor/widget/like_card.dart';

class LikePage extends StatelessWidget {
  const LikePage({Key? key}) : super(key: key);

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
              "ครูที่ฉันถูกใจ",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: COLOR.BLUE,
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder(
              future: getFollowing(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TutorCardModel> tutors =
                      snapshot.data as List<TutorCardModel>;

                  return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        TutorCardModel model = tutors[index];
                        return LikeCard(
                          model: model,
                          callback: () {
                            //Need to open Tutor's Profile Page
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => TutorPage(model: model),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemCount: tutors.length);
                } else if (snapshot.hasError) {
                  // return snapshot.error;
                  return Container();
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<TutorCardModel>> getFollowing() async {
    List<TutorCardModel> tutors = [];
    for (var uid in Globals.currentUser!.following) {
      dynamic result = await Util.getTutorProfile(uid);
      if (result is TutorCardModel) {
        tutors.add(result);
      }
    }

    return tutors;
  }
}
