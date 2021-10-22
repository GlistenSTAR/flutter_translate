import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/widget/radio_row.dart';

class TeachSubject extends StatefulWidget {
  TeachSubject({Key? key, required this.info}) : super(key: key);

  final Map<String, dynamic> info;

  @override
  _TeachSubjectState createState() => _TeachSubjectState();
}

class _TeachSubjectState extends State<TeachSubject> {
  List<TopicModel> allSubjects = TopicModel.getSubjects();
  late List<TopicModel> subjects;
  List<FilterModel> allLevels = FilterModel.getLevelMapping();
  late List<FilterModel> levels;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> subjectLevels = widget.info["subject_levels"] ?? {};
    subjects = subjectLevels.keys
        .map<TopicModel>(
          (e) => allSubjects.firstWhere(
            (element) => (element.titleID == e.toString() ||
                element.titleTH == e.toString()),
          ),
        )
        .toList();
    if (subjectLevels.length > 0) {
      levels = (subjectLevels.values.first as List)
          .map<FilterModel>(
            (e) => allLevels.firstWhere(
              (element) => (element.nameID == e.toString() ||
                  element.nameTH == e.toString()),
            ),
          )
          .toList();
    } else {
      levels = [];
    }
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "เลือกระดับชั้นและวิชา",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: COLOR.BLUE,
                    ),
                  ),
                  Text(
                    "ค่าได้ทำการบันทึกแล้วหลังกดบันทึก",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "เลือกระดับชั้น",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: COLOR.BLUE,
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 8,
                childAspectRatio:
                    (MediaQuery.of(context).size.width - 4 * 16) / (3 * 40.0),
              ),
              itemBuilder: (context, index) {
                FilterModel model = allLevels[index];
                bool exist = levels.contains(model);

                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (exist) {
                        levels.remove(model);
                      } else {
                        levels.add(model);
                      }
                    });
                  },
                  child: Text(model.nameTH),
                  style: ElevatedButton.styleFrom(
                    primary: !exist ? Colors.white : COLOR.YELLOW,
                    onPrimary: !exist ? COLOR.BLUE : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: !exist ? COLOR.BLUE : COLOR.YELLOW,
                      ),
                    ),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * .2, 40),
                  ),
                );
              },
              itemCount: allLevels.length,
            ),
            SizedBox(height: 16),
            Text(
              "วิชา",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: COLOR.BLUE,
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  TopicModel model = allSubjects[index];

                  return RadioRow(
                      title: model.titleTH,
                      selected: subjects.contains(model),
                      callback: () {
                        setState(() {
                          if (subjects.contains(model)) {
                            subjects.remove(model);
                          } else {
                            subjects.add(model);
                          }
                        });
                      });
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: allSubjects.length,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                updateInfo();
              },
              child: Text(
                "บันทึก",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                primary: COLOR.YELLOW,
                onPrimary: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> updatefirbase(
    String uid,
    Map<String, dynamic> subjectLevels,
    List<String> locations,
    Map<String, dynamic> data,
  ) {
    Util.deleteTutorFromSubjectPool(
        Globals.currentUser!.uid, subjectLevels, locations);
    Util.addTutorToSubjectPool(
        Globals.currentUser!.uid, subjectLevels, locations);
    return Util.updateTeachSubject(Globals.currentUser!.uid, data);
  }

  void updateInfo() async {
    List<String> levelList = levels.map<String>((e) => e.nameID).toList();
    Map<String, dynamic> subjectLevels = {};
    for (var subject in subjects) {
      Map<String, dynamic> temp = {subject.titleID: levelList};
      subjectLevels.addAll(temp);
    }

    Map<String, dynamic> data = {"subject_levels": subjectLevels};
    List<String> locations = widget.info["locations"].cast<String>();

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        updatefirbase(Globals.currentUser!.uid, subjectLevels, locations, data),
        message: Text('Please wait for a moment...'),
      ),
    );

    // await showDialog(
    //   context: context,
    //   builder: (context) => FutureProgressDialog(
    //     Util.deleteTutorFromSubjectPool(
    //         Globals.currentUser!.uid, subjectLevels, locations),
    //     message: Text('Please wait for a moment...'),
    //   ),
    // );

    // await showDialog(
    //   context: context,
    //   builder: (context) => FutureProgressDialog(
    //     Util.addTutorToSubjectPool(
    //         Globals.currentUser!.uid, subjectLevels, locations),
    //     message: Text('Please wait for a moment...'),
    //   ),
    // );

    // await showDialog(
    //   context: context,
    //   builder: (context) => FutureProgressDialog(
    //     Util.updateTeachSubject(Globals.currentUser!.uid, data),
    //     message: Text('Please wait for a moment...'),
    //   ),
    // );

    Navigator.of(context).pop(data);
  }
}
