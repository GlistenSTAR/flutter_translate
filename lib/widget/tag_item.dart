import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class TagItem extends StatelessWidget {
  const TagItem({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: COLOR.LIGHT_GREY,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          letterSpacing: 0.12,
          fontFamily: 'Prompt',
        ),
      ),
    );
  }
}
