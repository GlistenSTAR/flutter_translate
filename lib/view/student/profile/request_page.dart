import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/schedule/calendar_page.dart';
import 'package:tutor/view/student/search/filter_plane.dart';
import 'package:tutor/widget/request_cell.dart';
import 'package:tutor/widget/request_location_cell.dart';

class RequestPage extends StatefulWidget {
  RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final teOtherTopic = TextEditingController();
  final teHourRate = TextEditingController();

  TopicModel _selectedTopic = TopicModel.getSubjects().first;
  FilterModel _selectedLevel = FilterModel.getLevelMapping().first;
  FilterModel _selectedLocation = FilterModel.getLocationMapping().first;

  List<FilterModel> filterLocations = [],
      allLocations = FilterModel.getLocationMapping();

  DateTime _selectedDate = DateTime.now();
  bool showAlert = false, isSuccess = false;

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
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "รีเควสของฉัน",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: COLOR.BLUE,
                ),
              ),
              SizedBox(height: 16),
              RequestCell(
                title: "วิชา/ติวสอบ",
                description: _selectedTopic.titleTH,
                callback: () {
                  //Topic Sheet
                  showTopicSheet(context);
                },
              ),
              if (_selectedTopic.titleID.toLowerCase() == "others")
                TextField(
                  controller: teOtherTopic,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Other",
                    hintStyle: TextStyle(color: COLOR.DARK_GREY),
                  ),
                ),
              Divider(height: 8),
              RequestCell(
                title: "ระดับชั้น",
                description: _selectedLevel.nameTH,
                callback: () {
                  //Level Sheet
                  showFilterSheet(context, true);
                },
              ),
              Divider(height: 8),
              RequestCell(
                title: "วันที่เริ่มเรียน",
                description: Util.formatedStringFrom(_selectedDate),
                callback: () async {
                  //Date
                  dynamic result = await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black54,
                      pageBuilder: (_, __, ___) => CalendarPage(),
                    ),
                  );

                  if (result != null && result is DateTime) {
                    setState(() {
                      _selectedDate = result;
                    });
                  }
                },
              ),
              Divider(height: 8),
              TextField(
                controller: teHourRate,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "เรทต่อชั่วโมง",
                  hintStyle: TextStyle(color: COLOR.DARK_GREY),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Divider(),
              ////////////////
              // Locations,
              ///////////////
              // RequestLocationCell(
              //   title: "สถานที่เรียน",
              //   description: _selectedLocation.nameTH,
              //   callback: () {
              //     //Level Sheet
              //     showFilterSheet(false);
              //   },
              // ),
              InkWell(
                onTap: () async {
                  dynamic result = await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black54,
                      pageBuilder: (_, __, ___) => FilterPlane(
                        title: "สถานที่",
                        filters: filterLocations,
                        models: allLocations,
                      ),
                    ),
                  );

                  if (result != null && result is List<FilterModel>) {
                    setState(() {
                      filterLocations = result;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      "สถานที่เรียน",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: List.generate(
                          filterLocations.length,
                          (index) {
                            FilterModel location = filterLocations[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: COLOR.LIGHT_GREY,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 2,
                              ),
                              child: Text(
                                location.nameTH,
                                style: TextStyle(
                                  color: COLOR.YELLOW,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  //Make request
                  String result = await showDialog(
                    context: context,
                    builder: (context) => FutureProgressDialog(
                      addStudentRequest(),
                      message: Text('Please wait for a moment...'),
                    ),
                  );

                  if (result == "Success") {
                    showResult(context, "Success", "Request added successfully",
                        () {
                      Navigator.of(context).pop();
                    });
                  } else {
                    showResult(
                        context, "Failure", "Sorry unable to add request", () {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Text(
                  "รีเควส",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    primary: COLOR.YELLOW,
                    onPrimary: Colors.white,
                    minimumSize: Size(MediaQuery.of(context).size.width, 40)),
              ),
            ],
          )),
    );
  }

  void showTopicSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("เลือก"),
        actions: TopicModel.getSubjects()
            .map<CupertinoActionSheetAction>((e) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedTopic = e;
                    });
                  },
                  child: Text(e.titleTH),
                ))
            .toList(),
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

  void showFilterSheet(BuildContext context, bool isLevel) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text("เลือก"),
        actions: isLevel
            ? FilterModel.getLevelMapping()
                .map<CupertinoActionSheetAction>(
                    (e) => CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _selectedLevel = e;
                            });
                          },
                          child: Text(e.nameTH),
                        ))
                .toList()
            : FilterModel.getLevelMapping()
                .map<CupertinoActionSheetAction>(
                    (e) => CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _selectedLocation = e;
                            });
                          },
                          child: Text(e.nameTH),
                        ))
                .toList(),
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

  Future<String> addStudentRequest() async {
    dynamic student =
        await Util.getStudent(Globals.currentUser!.uid);
    if (student is Map) {
      String topic;
      if (_selectedTopic.titleID == "others") {
        topic = teOtherTopic.text.trim();
      } else {
        topic = _selectedTopic.titleID;
      }

      Map<String, dynamic> data = {
        "topic": topic,
        "level": _selectedLevel.nameID,
        "level_th": _selectedLevel.nameTH,
        "startDate": Util.formatedStringFrom(_selectedDate, locale: "en"),
        "rate": teHourRate.text.trim(),
        "location": filterLocations.map<String>((e) => e.nameID).join(", "),
        "location_th": filterLocations.map<String>((e) => e.nameTH).join(", "),
        "requestDate": DateTime.now(),
        "name": student["name"],
        "studentID": Globals.currentUser!.uid,
        "displayImage": student["display_img"],
        "isBooked": false
      };

      await FirebaseFirestore.instance
          .collection("Application")
          .doc("StudentRequest")
          .collection("AllRequests")
          .add(data);

      return "Success";
    } else {
      return "Failure";
    }
  }

  void showResult(BuildContext context, String title, String description,
      VoidCallback callback) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        content: Text(
          description,
          style: TextStyle(fontSize: 11),
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
