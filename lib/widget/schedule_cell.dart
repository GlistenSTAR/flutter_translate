import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCell extends StatelessWidget {
  const ScheduleCell({Key? key, required this.dateTime, this.top, this.bottom})
      : super(key: key);

  final DateTime dateTime;
  final VoidCallback? top, bottom;

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat("HH:mm");
    String time = formatter.format(dateTime);

    return Row(children: [
      Container(
        width: 48,
        child: Text(
          time,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      ),
      Container(width: 8, child: Divider(height: 60)),
      Expanded(
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: top,
              child: Container(height: 28),
            ),
            Divider(height: 2),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: bottom,
              child: Container(height: 28),
            ),
          ],
        ),
      ),
    ]);
  }
}
