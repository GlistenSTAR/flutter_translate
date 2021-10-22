import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/view/student/search/tutor_pool.dart';
import 'package:tutor/widget/subject_switch.dart';

class SearchView extends StatefulWidget {
  SearchView({Key? key}) : super(key: key);

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  final teSearch = TextEditingController();

  List<TopicModel> allSubjects = TopicModel.getSubjects();
  List<TopicModel> allTestings = TopicModel.getTests();
  late List<TopicModel> filteredItems;

  @override
  void initState() {
    super.initState();

    if (Globals.isSubjectMode) {
      filteredItems = allSubjects;
    } else {
      filteredItems = allTestings;
    }

    teSearch.addListener(_onSearch);
  }

  @override
  void dispose() {
    teSearch.removeListener(_onSearch);
    super.dispose();
  }

  void _onSearch() {
    String search = teSearch.text.trim().toLowerCase();
    if (Globals.isSubjectMode) {
      filteredItems = allSubjects;
    } else {
      filteredItems = allTestings;
    }

    if (search.isNotEmpty) {
      filteredItems = filteredItems.where((element) {
        return element.longNameTH.toLowerCase().contains(search);
      }).toList();
    }

    setState(() {});
  }

  void updateState() {
    teSearch.clear();
    setState(() {
      if (Globals.isSubjectMode) {
        filteredItems = allSubjects;
      } else {
        filteredItems = allTestings;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SubjectSwitch(
            isSubject: Globals.isSubjectMode,
            onSubject: () {
              teSearch.clear();
              setState(() {
                Globals.isSubjectMode = true;
                filteredItems = allSubjects;
              });
            },
            onTest: () {
              teSearch.clear();
              setState(() {
                Globals.isSubjectMode = false;
                filteredItems = allTestings;
              });
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: COLOR.LIGHT_GREY,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: teSearch,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Globals.isSubjectMode ? "ค้นหาวิชา" : "ค้นหาที่จะสอบ",
                hintStyle: TextStyle(color: COLOR.DARK),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    teSearch.clear();
                  },
                  icon: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      radius: 10,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.only(bottom: 16),
                itemBuilder: (context, index) {
                  TopicModel topicModel = filteredItems[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                TutorPool(topicModel: topicModel),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: COLOR.LIGHT_GREY),
                                image: DecorationImage(
                                  image: AssetImage(topicModel.topic ==
                                          "subject"
                                      ? "images/subject/${topicModel.iconName}.png"
                                      : "images/test/${topicModel.iconName}.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                topicModel.titleTH,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: COLOR.YELLOW,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemCount: filteredItems.length),
          )
        ],
      ),
    );
  }
}
