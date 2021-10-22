import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tutor/utils/const.dart';

class RatingPercent extends StatelessWidget {
  const RatingPercent({Key? key, required this.rating, required this.percent})
      : super(key: key);

  final int rating;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          child: Row(children: [
            Text(
              rating.toString(),
              style: TextStyle(fontSize: 15),
            ),
            Icon(
              Icons.star,
              color: COLOR.YELLOW,
            ),
          ]),
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 20,
            animation: true,
            animationDuration: 2000,
            percent: percent,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: COLOR.YELLOW.withOpacity(0.8),
            backgroundColor: COLOR.BLUE.withOpacity(0.2),
          ),
        ),
        Container(
          width: 60,
          padding: EdgeInsets.only(left: 16),
          child: Text(
            (percent * 100).toInt().toString() + "%",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
