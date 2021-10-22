import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/widget/radio_row.dart';

class TeachTest extends StatefulWidget {
  TeachTest({Key? key, required this.info}) : super(key: key);

  final Map<String, dynamic> info;

  @override
  _TeachTestState createState() => _TeachTestState();
}

class _TeachTestState extends State<TeachTest> {
  List<TopicModel> allTest = TopicModel.getTests();
  late List<TopicModel> tests;

  @override
  void initState() {
    super.initState();

    List testings = widget.info["testings"] ?? [];

    tests = testings
        .map<TopicModel>(
          (e) => allTest.firstWhere((element) =>
              (element.titleID == e.toString() ||
                  element.titleTH == e.toString())),
        )
        .toList();
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
            Text(
              "เลือกติวสอบที่สอน",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  TopicModel test = allTest[index];

                  return RadioRow(
                      title: test.titleTH,
                      selected: tests.contains(test),
                      callback: () {
                        setState(() {
                          if (tests.contains(test)) {
                            tests.remove(test);
                          } else {
                            tests.add(test);
                          }
                        });
                      });
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: allTest.length,
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

  void updateInfo() async {
    List<String> testings = tests.map<String>((e) => e.titleID).toList();

    Map<String, dynamic> data = {"testings": testings};

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.deleteTutorFromTestingPool(Globals.currentUser!.uid,
            widget.info["testings"] ?? [], widget.info["locations"] ?? []),
        message: Text('Please wait for a moment...'),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.addTutorToTestingPool(
            Globals.currentUser!.uid, testings, widget.info["locations"] ?? []),
        message: Text('Please wait for a moment...'),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.updateTeachTesting(Globals.currentUser!.uid, data),
        message: Text('Please wait for a moment...'),
      ),
    );

    Navigator.of(context).pop(data);
  }
}
