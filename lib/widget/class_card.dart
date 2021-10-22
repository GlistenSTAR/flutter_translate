import 'package:flutter/material.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/utils/const.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({Key? key, required this.model, required this.callback})
      : super(key: key);

  final ClassModel model;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(16),
        // ),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.statusChanged ? "เปลี่ยนแปลง" : "",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.tutorNickname,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "สถานะ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: COLOR.BLUE,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "วันที่: ${model.date}\nเวลา: ${model.time}\nสถานที่: ${model.location}",
//                   "วันที่: ${model.date}\nเวลา: ${model.time}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    model.status,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: COLOR.BLUE,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
