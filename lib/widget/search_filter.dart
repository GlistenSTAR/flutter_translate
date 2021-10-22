import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({Key? key, required this.title, this.callback})
      : super(key: key);

  final String title;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: COLOR.BLUE, width: 2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: COLOR.BLUE),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: COLOR.YELLOW,
            ),
          ],
        ),
      ),
    );
  }
}
