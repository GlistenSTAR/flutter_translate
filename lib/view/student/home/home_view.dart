import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/model/TrendModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/view/student/profile/request_page.dart';
import 'package:tutor/view/student/search/tutor_pool.dart';
import 'package:tutor/widget/home_topic.dart';
import 'package:tutor/widget/home_trend.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    List<TopicModel> subjects = TopicModel.getHomeSubject();
    List<TopicModel> testings = TopicModel.getHomeTest();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "วิชายอดฮิต",
              style: TextStyle(
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: COLOR.BLUE,
                letterSpacing: 1,
              ),
            ),
          ),
          _trendWidget("Trending_Subjects"),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "ติวสอบยอดฮิต",
              style: TextStyle(
                fontFamily: 'Prompt',
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: COLOR.BLUE,
                letterSpacing: 1,
              ),
            ),
          ),
          _trendWidget("Trending_Testings"),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "วิชา",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: COLOR.BLUE,
                    letterSpacing: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Globals.isSubjectMode = true;
                    onSearch();
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "ทั้งหมด ",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w900,
                          color: COLOR.YELLOW,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: COLOR.YELLOW,
                              size: 18,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 110,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  TopicModel topicModel = subjects[index];
                  return HomeTopic(
                      topicModel: topicModel,
                      callback: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                TutorPool(topicModel: topicModel),
                          ),
                        );
                      });
                },
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemCount: subjects.length),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ติวสอบ",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: COLOR.BLUE,
                    letterSpacing: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Globals.isSubjectMode = false;
                    onSearch();
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "ทั้งหมด ",
                        style: TextStyle(
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.w900,
                          color: COLOR.YELLOW,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: COLOR.YELLOW,
                              size: 18,
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 110,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  TopicModel topicModel = testings[index];

                  return HomeTopic(
                      topicModel: topicModel,
                      callback: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                TutorPool(topicModel: topicModel),
                          ),
                        );
                      });
                },
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemCount: testings.length),
          ),
          Divider(
            indent: 8,
            endIndent: 8,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                //My Request
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => RequestPage(),
                  ),
                );
              },
              child: Text(
                "รีเควสของฉัน",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width, 48),
                primary: COLOR.BLUE,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _trendWidget(String collection) {
    return Container(
      height: 120,
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection(collection).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Object?>> docs = snapshot.data!.docs;
            List<TrendModel> models = docs.map<TrendModel>((e) {
              Map<String, dynamic> data = e.data() as Map<String, dynamic>;

              String topic = data["topic"] ?? "";
              String title = data["title"] ?? data["title_id"] ?? "";
              String img = data["img"] ?? "";
              int rank = int.tryParse(e.id) ?? 0;

              return TrendModel(
                  topic: topic, rank: rank, titleID: title, imgUrl: img);
            }).toList();
            return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  //Popular subjects
                  TrendModel trendModel = models[index];

                  return HomeTrend(
                      trendModel: trendModel,
                      callback: () {
                        List<TopicModel> allTopic;
                        if (trendModel.topic == "subject") {
                          allTopic = TopicModel.getSubjects();
                        } else {
                          allTopic = TopicModel.getTests();
                        }

                        TopicModel topicModel = allTopic.firstWhere(
                          (element) => element.titleID == trendModel.titleID,
                          orElse: () =>
                              TopicModel.fromJson(<String, dynamic>{}),
                        );

                        if (topicModel.titleID.isNotEmpty) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) =>
                                  TutorPool(topicModel: topicModel),
                            ),
                          );
                        }
                      });
                },
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemCount: models.length);
          } else if (snapshot.hasError) {
            return Text("Connection Error");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
