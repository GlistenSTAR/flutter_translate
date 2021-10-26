import 'package:flutter/material.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/utils/const.dart';

class HomeTopic extends StatelessWidget {
  const HomeTopic({Key? key, required this.topicModel, required this.callback})
      : super(key: key);

  final TopicModel topicModel;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 2)
                  ],
                  image: DecorationImage(
                      image: AssetImage(topicModel.topic == "subject"
                          ? "images/subject/${topicModel.iconName}.png"
                          : "images/test/${topicModel.iconName}.png"),
                      fit: BoxFit.cover),
                  border: Border.all(color: COLOR.LIGHT_GREY),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            topicModel.titleTH,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
