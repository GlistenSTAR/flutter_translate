import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class ProfileCell extends StatelessWidget {
  const ProfileCell(
      {Key? key, required this.title, this.titleColor, this.callback})
      : super(key: key);

  final String title;
  final Color? titleColor;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor ?? COLOR.YELLOW,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: COLOR.DARK_GREY,
            size: 16,
          ),
        ],
      ),
    );
  }
}
