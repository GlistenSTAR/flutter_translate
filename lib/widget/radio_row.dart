import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class RadioRow extends StatelessWidget {
  const RadioRow({
    Key? key,
    required this.title,
    required this.selected,
    required this.callback,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          selected
              ? Icon(
                  Icons.radio_button_checked_outlined,
                  color: COLOR.YELLOW,
                )
              : Icon(
                  Icons.radio_button_unchecked_outlined,
                  color: COLOR.DARK,
                )
        ],
      ),
    );
  }
}
