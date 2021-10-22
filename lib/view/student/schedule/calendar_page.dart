import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key, this.date}) : super(key: key);

  final DateTime? date;

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _targetDateTime;
  late String _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.date ?? DateTime.now();
    updateMonth(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(maxHeight: 450),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ปฎิทิน",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          color: COLOR.BLUE,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            Navigator.of(context).pop(_selectedDate),
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _currentMonth,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: COLOR.BLUE,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          DateTime date = DateTime(_targetDateTime.year,
                              _targetDateTime.month - 1, 1);

                          updateMonth(date);
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          DateTime date = DateTime(_targetDateTime.year,
                              _targetDateTime.month + 1, 1);

                          updateMonth(date);
                        },
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                  Flexible(
                    child: CalendarCarousel(
                      todayBorderColor: COLOR.BLUE,
                      onDayPressed: (date, events) {
                        this.setState(() => _selectedDate = date);
                      },
                      daysHaveCircularBorder: true,
                      showOnlyCurrentMonthDate: false,
                      weekendTextStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      thisMonthDayBorderColor: Colors.transparent,
                      weekFormat: false,
                      locale: "th",
                      customWeekDayBuilder: (index, weekday) {
                        return Text(
                          weekday,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        );
                      },
                      firstDayOfWeek: 1,
                      // markedDatesMap: _markedDateMap,
                      // height: 420.0,

                      selectedDateTime: _selectedDate,
                      targetDateTime: _targetDateTime,
                      customGridViewPhysics: NeverScrollableScrollPhysics(),
                      markedDateCustomShapeBorder:
                          CircleBorder(side: BorderSide(color: Colors.yellow)),
                      markedDateCustomTextStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                      showHeader: false,
                      todayTextStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      // markedDateShowIcon: true,
                      // markedDateIconMaxShown: 2,
                      // markedDateIconBuilder: (event) {
                      //   return event.icon;
                      // },
                      // markedDateMoreShowTotal:
                      //     true,
                      todayButtonColor: Colors.white,
                      selectedDayTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      minSelectedDate:
                          DateTime.now().subtract(Duration(days: 36500)),
                      maxSelectedDate: DateTime.now().add(Duration(days: 365)),
                      selectedDayButtonColor: COLOR.YELLOW,
                      selectedDayBorderColor: Colors.transparent,
                      prevDaysTextStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      inactiveDaysTextStyle: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 16,
                      ),
                      daysTextStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      onCalendarChanged: updateMonth,
                      onDayLongPressed: (DateTime date) {
                        print('long pressed date $date');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateMonth(DateTime date) {
    _targetDateTime = date;

    DateFormat formatter = DateFormat.MMMM();
    _currentMonth =
        formatter.format(date) + " " + Util.getBuddhistCalendarYear(date);

    if (mounted) setState(() {});
  }
}
