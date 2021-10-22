import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/schedule/calendar_page.dart';

class ReceiptPage extends StatefulWidget {
  ReceiptPage({Key? key}) : super(key: key);

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final teTitle = TextEditingController();
  final teHour = TextEditingController();
  final teRate = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay start = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay end = TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    teHour.text = "1 Hour";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Flexible(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            height: 585,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
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
                  "ใบยืนยันคลาสเรียน",
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Divider(),
                TextField(
                  controller: teTitle,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "วิชา/ติวสอบ*"),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Divider(),
                SizedBox(height: 8),
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
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
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
                          teHour.text = "1 Hour";
                        });
                      }
                    },
                  );
                }),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
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
                          int minutes = getDurationMinutes(start, end);
                          int min = minutes % 60;
                          if (min == 0) {
                            teHour.text = "${minutes ~/ 60} hours";
                          } else {
                            teHour.text = "${minutes ~/ 60} hours $min minutes";
                          }
                        });
                      }
                    },
                  );
                }),
                SizedBox(height: 8),
                Divider(),
                TextField(
                  controller: teHour,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "จำนวนชม./ครั้ง*"),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Divider(),
                TextField(
                  controller: teRate,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "ค่าเรียนต่อชั่วโมง(บาท)*",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      String title = teTitle.text.trim();
                      String rateString = teRate.text.trim();
                      int minutes = getDurationMinutes(start, end);
                      String hours = (minutes / 60).toStringAsFixed(2);

                      if (title.isEmpty || rateString.isEmpty) {
                        showToast("กรุณากรอกข้อมูลให้ครบ");
                        return;
                      }

                      double? rate = double.tryParse(rateString);
                      if (rate == null) {
                        showToast("Invalid number");
                        return;
                      }

                      double amount =
                          rate * getDurationMinutes(start, end) / 60;

                      Map<String, dynamic> data = {
                        "amount": amount,
                        "class_title": title,
                        "class_date":
                            DateFormat("dd/MM/yyyy").format(_selectedDate),
                        "class_beginTime":
                            DateFormat.Hm("en").format(getDateFromTime(start)),
                        "class_endTime":
                            DateFormat.Hm("en").format(getDateFromTime(end)),
                        "class_hour": hours,
                        "class_price_hour": rateString,
                        "class_time": DateFormat.Hm("en")
                                .format(getDateFromTime(start)) +
                            "-" +
                            DateFormat.Hm("en").format(getDateFromTime(end)),
                        "class_status": "pending",
                        "status_changed": true,
                      };

                      Navigator.of(context).pop(data);
                    },
                    child: Text(
                      "ส่งใบยืนยันคลาสเรียน",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: COLOR.YELLOW,
                      padding: EdgeInsets.only(top: 8, bottom: 8),
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
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            description,
            style: TextStyle(fontSize: 16),
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
