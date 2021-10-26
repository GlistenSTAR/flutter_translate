import 'package:flutter/material.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/utils/const.dart';

class TClassCard extends StatelessWidget {
  const TClassCard({Key? key, required this.model, required this.callback})
      : super(key: key);

  final ClassModel model;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final dateArray = model.date.split("-");
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 4,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Prompt',
                    ),
                  ),
                  Text(
                    model.studentNickname,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Prompt',
                    ),
                  ),
                  Text(
                    "วันที่: ${dateArray[1]}/${dateArray[2]}/${dateArray[0]}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Prompt',
                    ),
                  ),
                  Text(
                    "เวลา: ${model.time}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Prompt',
                    ),
                  ),
                  Text(
                    "สถานที่: ${model.location}",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Prompt',
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "สถานะ",
                    style: TextStyle(
                      color: COLOR.BLUE,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    model.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: COLOR.BLUE,
                      fontSize: 16,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
