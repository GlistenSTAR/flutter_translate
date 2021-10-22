import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/schedule/calendar_page.dart';

class ChangeClass extends StatefulWidget {
  ChangeClass({Key? key, required this.model}) : super(key: key);

  final ClassModel model;

  @override
  _ChangeClassState createState() => _ChangeClassState();
}

class _ChangeClassState extends State<ChangeClass> {
  late DateTime _selectedDate;
  late TimeOfDay start, end;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.model.begin ?? DateTime.now();
    DateTime endDate = widget.model.end ?? DateTime.now();
    start = TimeOfDay(hour: _selectedDate.hour, minute: _selectedDate.minute);
    end = TimeOfDay(hour: endDate.hour, minute: endDate.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                )),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 40,
                    ),
                  ),
                ),
                Text(
                  "เปลี่ยนวันและเวลาสอน",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Divider(),
                _detailRow("วันที่เรียน", Util.getBuddhistDate(_selectedDate),
                    callback: () async {
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
                }),
                Divider(),
                _detailRow("เวลาเริ่มเรียน", start.format(context),
                    callback: () {
                  showCustomTimePicker(
                      context: context,
                      // It is a must if you provide selectableTimePredicate
                      onFailValidation: (context) =>
                          showToast('Unavailable selection'),
                      initialTime:
                          TimeOfDay(hour: start.hour, minute: start.minute),
                      selectableTimePredicate: (time) =>
                          time!.hour >= 8 &&
                          time.hour <= 22 &&
                          time.minute % 5 == 0).then(
                    (time) {
                      if (time != null) {
                        setState(() {
                          start = time;
                          end = TimeOfDay(
                              hour: start.hour + 1, minute: start.minute);
                        });
                      }
                    },
                  );
                }),
                Divider(),
                _detailRow("เวลาเรียนเสร็จ", end.format(context), callback: () {
                  showCustomTimePicker(
                      context: context,
                      // It is a must if you provide selectableTimePredicate
                      onFailValidation: (context) =>
                          showToast('Unavailable selection'),
                      initialTime:
                          TimeOfDay(hour: start.hour + 1, minute: start.minute),
                      selectableTimePredicate: (time) =>
                          time!.hour > start.hour &&
                          time.hour <= 23 &&
                          getDurationMinutes(start, time) >= 60 &&
                          time.minute % 5 == 0).then(
                    (time) {
                      if (time != null) {
                        setState(() {
                          end = time;
                        });
                      }
                    },
                  );
                }),
                Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      int minutes = getDurationMinutes(start, end);
                      String hours = (minutes / 60).toStringAsFixed(2);

                      Map<String, dynamic> data = {
                        "class_date":
                            DateFormat("yyyy-MM-dd").format(_selectedDate),
                        "class_beginTime":
                            DateFormat.Hm("en").format(getDateFromTime(start)),
                        "class_endTime":
                            DateFormat.Hm("en").format(getDateFromTime(end)),
                        "class_hour": hours,
                        "class_time": DateFormat.Hm("en")
                                .format(getDateFromTime(start)) +
                            "-" +
                            DateFormat.Hm("en").format(getDateFromTime(end)),
                      };

                      Navigator.of(context).pop(data);
                    },
                    child: Text(
                      "บันทึก",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: COLOR.YELLOW,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String description,
      {VoidCallback? callback}) {
    return InkWell(
      onTap: callback,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            description,
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }

  int getDurationMinutes(TimeOfDay start, TimeOfDay end) {
    DateTime now = DateTime.now();
    DateTime startTime =
        DateTime(now.year, now.month, now.day, start.hour, start.minute);
    DateTime endTime =
        DateTime(now.year, now.month, now.day, end.hour, end.minute);
    int minutes = endTime.difference(startTime).inMinutes;
    return minutes;
  }

  DateTime getDateFromTime(TimeOfDay timeOfDay) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return dateTime;
  }
}
