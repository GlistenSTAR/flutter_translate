import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/widget/choose_location.dart';
import 'package:tutor/widget/select_location.dart';

class TutorBooking extends StatefulWidget {
  TutorBooking({Key? key, required this.model, required this.date})
      : super(key: key);

  final TutorCardModel model;
  final DateTime date;

  @override
  _TutorBookingState createState() => _TutorBookingState();
}

class _TutorBookingState extends State<TutorBooking> {
  final teTitle = TextEditingController();
  final teLocation = TextEditingController();
  final teRate = TextEditingController();
  late TimeOfDay start, end;

  late List<FilterModel> allLocations;
  late FilterModel selectLocation;

  @override
  void initState() {
    super.initState();

    start = TimeOfDay(hour: widget.date.hour, minute: 0);
    end = TimeOfDay(hour: widget.date.hour + 1, minute: 0);

    allLocations = FilterModel.getLocationMapping();
    selectLocation =
        FilterModel(order: 0, nameID: "", nameTH: "", checked: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(42),
          child: SingleChildScrollView(
            child: Column(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.model.nickname,
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      color: COLOR.BLUE,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Divider(thickness: 1),
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
                          time!.hour == widget.date.hour &&
                          time.minute % 5 == 0).then(
                    (time) {
                      if (time != null) {
                        setState(() {
                          start = time;
                          end = TimeOfDay(
                              hour: start.hour + 1, minute: start.minute);
                          // teHour.text = "1 Hour";
                        });
                      }
                    },
                  );
                }),
                SizedBox(height: 8),
                Divider(thickness: 1),
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
                        });
                      }
                    },
                  );
                }),
                SizedBox(height: 8),
                Divider(thickness: 1),
                SizedBox(height: 8),
                _detailRow(
                  "วันที่เรียน",
                  Util.getBuddhistDate(widget.date),
                ),
                SizedBox(height: 8),
                Divider(thickness: 1),
                TextField(
                  controller: teTitle,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "วิชา/ติวสอบ"),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Divider(thickness: 1),
                TextField(
                  controller: teRate,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "ราคา (บาท/ชม.)",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Divider(thickness: 1),
                // TextField(
                //   controller: teLocation,
                //   decoration: InputDecoration(
                //       border: InputBorder.none, hintText: "สถานที่เรียน"),
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     fontSize: 18,
                //   ),
                // ),
                ChooseLocation(
                  title: "สถานที่เรียน",
                  placeholder: "สถานที่เรียน",
                  selected: selectLocation,
                  callback: () async {
                    dynamic result = await Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black54,
                        pageBuilder: (_, __, ___) => SelectLocation(
                          title: "สถานที่เรียน",
                          location: selectLocation,
                          models: allLocations,
                        ),
                      ),
                    );

                    if (result != null && result is FilterModel) {
                      setState(() {
                        selectLocation = result;
                      });
                    }
                  },
                ),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      String title = teTitle.text.trim();
                      String rateString = teRate.text.trim();
                      String location = teLocation.text.trim();
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
                            DateFormat("dd/MM/yy").format(widget.date),
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
                        "class_location": selectLocation.nameID,
                      };

                      Navigator.of(context).pop(data);
                    },
                    child: Text(
                      "จองคลาส",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
        ),
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
