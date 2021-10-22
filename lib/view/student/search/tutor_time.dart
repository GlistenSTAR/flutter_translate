import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/model/user.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/chat/chat_page.dart';
import 'package:tutor/view/student/schedule/calendar_page.dart';
import 'package:tutor/view/student/search/tutor_booking.dart';
import 'package:tutor/widget/schedule_cell.dart';

class TutorTime extends StatefulWidget {
  TutorTime({Key? key, required this.model}) : super(key: key);

  final TutorCardModel model;

  @override
  _TutorTimeState createState() => _TutorTimeState();
}

class _TutorTimeState extends State<TutorTime> {
  late DateTime _currentDate, _weekDate;
  late String _currentMonth;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    _currentDate = DateTime(now.year, now.month, now.day);

    //First day of week is Monday
    DateTime date = _currentDate.subtract(Duration(days: now.weekday - 1));
    updateWeek(date);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "ตารางเวลา",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: COLOR.BLUE,
              ),
            ),
          ),
          Container(
            color: COLOR.YELLOW,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _currentMonth,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    dynamic result = await Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black54,
                        pageBuilder: (_, __, ___) => CalendarPage(),
                      ),
                    );

                    if (result != null && result is DateTime) {
                      setState(() {
                        _currentDate = result;
                      });
                      updateWeek(result);
                    }
                  },
                  child: Image.asset("images/calendar_today.png"),
                )
              ],
            ),
          ),
          Container(
            color: COLOR.BLUE,
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    //Previous
                    DateTime date = _weekDate.subtract(Duration(days: 7));
                    updateWeek(date);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime date = _weekDate.add(Duration(days: index));

                        DateFormat abbrWeek = DateFormat.E();
                        String week = abbrWeek.format(date);
                        DateFormat formatter = DateFormat("dd/MM");
                        String dayString = formatter.format(date);

                        bool isActive = DateFormat.yMd().format(_currentDate) ==
                            DateFormat.yMd().format(date);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _currentDate = date;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isActive ? COLOR.YELLOW : Colors.transparent,
                            ),
                            padding: EdgeInsets.all(7),
                            child: Column(
                              children: [
                                Text(
                                  week,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  dayString,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => Container(),
                      itemCount: 7),
                ),
                InkWell(
                  onTap: () {
                    //Next
                    DateTime date = _weekDate.add(Duration(days: 7));
                    updateWeek(date);
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: FutureBuilder<Map<String, dynamic>>(
                future: getClassInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data = snapshot.data!;
                    List<ClassModel> classes = data["class"];
                    List<int> slots = data["slot"];

                    DateTime topTime = DateTime(_currentDate.year,
                        _currentDate.month, _currentDate.day, 8);

                    List<Widget> widgets = classes.map<Widget>((e) {
                      Duration topDuration = e.begin!.difference(topTime);
                      Duration classDuration = e.end!.difference(e.begin!);

                      return Positioned(
                          top: 30 + topDuration.inMinutes.toDouble(),
                          child: InkWell(
                            onTap: () {
                              showClassDetail(context, e);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 88,
                              height: classDuration.inMinutes.toDouble(),
                              margin: EdgeInsets.only(left: 56),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: COLOR.YELLOW,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    e.beginTime,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    e.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }).toList();

                    List<Widget> invalidSlots = slots.map<Widget>((e) {
                      return Positioned(
                          top: 30 + e * 60,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width - 88,
                              height: 60,
                              margin: EdgeInsets.only(left: 56),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: COLOR.BACK_GREY,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "ไม่สามารถจองได้",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ));
                    }).toList();

                    widgets.insert(0, _backgroundWidget());
                    widgets.addAll(invalidSlots);

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: widgets,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _backgroundWidget() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        DateTime dateTime = DateTime(_currentDate.year, _currentDate.month,
            _currentDate.day, (index + 8));
        return ScheduleCell(
            dateTime: dateTime,
            top: () {
              if (index == 0) return;
              showBookPage(dateTime.subtract(Duration(hours: 1)));
            },
            bottom: () {
              if (index == 15) return;
              showBookPage(dateTime);
            });
      },
      itemCount: 16,
    );
  }

  void showClassDetail(BuildContext context, ClassModel model) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "รายละเอียดคลาสเรียน",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 21,
                    color: COLOR.BLUE,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.cancel_outlined),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: model.previous == null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getNewDetail(model),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "คลาสเรียนเดิม",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: COLOR.DARK_GREY,
                        ),
                      ),
                      Text(
                        getPrevDetail(model),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: COLOR.DARK_GREY,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "คลาสเรียนใหม่",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        getNewDetail(model),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          "*คุณได้เปลี่ยนแปลงวัน/เวลาแล้ว 1 ครั้ง คุณไม่สามารถเปลี่ยนแปลงคลาสเรียนนี้ได้อีก",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  String getNewDetail(ClassModel model) {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    String str = model.title +
        "\n" +
        model.studentNickname +
        "\nวัน " +
        formatter.format(Util.toBuddhist(model.begin!)) +
        "\nเวลา " +
        model.time;

    return str;
  }

  String getPrevDetail(ClassModel model) {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    DateTime prev = formatter.parse(model.previous!["class_date"]);
    String str = model.title +
        "\n" +
        model.studentNickname +
        "\nวัน " +
        formatter.format(Util.toBuddhist(prev)) +
        "\nเวลา " +
        model.previous!["class_time"];

    return str;
  }

  void updateWeek(DateTime date) {
    _weekDate = date;

    DateFormat formatter = DateFormat.MMMM();
    _currentMonth =
        formatter.format(date) + " " + Util.getBuddhistCalendarYear(date);

    if (mounted) setState(() {});
  }

  Future<Map<String, dynamic>> getClassInfo() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("ClassIDs")
        .where("tutor_id", isEqualTo: widget.model.tutorID)
        .where("class_date",
            isEqualTo: DateFormat("yyyy-MM-dd").format(_currentDate))
        .orderBy("class_beginTime")
        .get();

    List<ClassModel> models = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      dynamic student = await Util.getStudent(data['student_id']);
      if (student is Map) {
        data['student_nickname'] = student["nickname"];
        data['student_name'] = student["name"];
        data['student_address'] = student["address"];
      }

      String status;
      switch (data["class_status"] ?? "") {
        case "00":
          status = "จองแล้ว";
          break;
        case "pending":
          status = "รอการจ่ายเงิน";
          break;
        case "done":
          status = "สอนเสร็จ";
          break;
        default:
          status = "รอการยืนยันการเรียน";
          break;
      }
      data["status"] = status;
      print(data);

      ClassModel model = ClassModel.fromJson(data);
      model.begin = dateFromHour(data['class_beginTime'] ?? "");
      model.end = dateFromHour(data['class_endTime'] ?? "");

      print(model.begin);
      print(model.end);

      models.add(model);
    }

    List<int> slots =
        await Util.getUnavailabeSlot(widget.model.tutorID, _currentDate);
    Map<String, dynamic> data = {
      "class": models,
      "slot": slots,
    };

    return data;
  }

  DateTime? dateFromHour(String str) {
    DateFormat formatter = DateFormat("HH:mm");
    try {
      DateTime time = formatter.parse(str);
      return DateTime(_currentDate.year, _currentDate.month, _currentDate.day,
          time.hour, time.minute);
    } catch (e) {
      return null;
    }
  }

  void showBookPage(DateTime dateTime) async {
    dynamic result = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black54,
        pageBuilder: (_, __, ___) =>
            TutorBooking(model: widget.model, date: dateTime),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      DateFormat format = DateFormat("dd/MM/yy");
      String dateString = format.format(Util.toBuddhist(_currentDate));

      String roomID = "${Globals.currentUser!.uid}_${widget.model.tutorID}";
      String beginText = "New Booking \n" +
          "หัวข้อ: ${result['class_title']} " +
          "\nราคา: ${result['class_price_hour']}" +
          "\nวัน: $dateString" +
          "\nเวลา: ${result['class_time']}" +
          "\nสถานที่: ${result['class_location']}";

      User tutor = User(
        isTutor: true,
        uid: widget.model.tutorID,
        nickname: widget.model.nickname,
        name: widget.model.name,
        profileUrl: widget.model.profileUrl,
        address: "",
        idCard: "",
        following: [],
      );
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => ChatPage(
            requestID: "",
            roomID: roomID,
            partner: tutor,
            begintText: beginText,
          ),
        ),
      );
    }
  }
}
