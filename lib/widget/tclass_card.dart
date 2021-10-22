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
    return InkWell(
      onTap: callback,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.studentNickname,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "วันที่: ${model.date}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "เวลา: ${model.time}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "สถานะ",
                    style: TextStyle(color: COLOR.BLUE),
                  ),
                  Text(
                    model.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: COLOR.BLUE,
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
