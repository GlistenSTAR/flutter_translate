import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class RequestLocationCell extends StatelessWidget {
  const RequestLocationCell({
    Key? key,
    required this.title,
    required this.description,
    this.callback,
  }) : super(key: key);

  final String title, description;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: callback,
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            primary: COLOR.LIGHT_GREY,
            onPrimary: COLOR.YELLOW,
          ),
        ),
      ],
    );
  }
}
