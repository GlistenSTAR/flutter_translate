import 'package:flutter/material.dart';
import 'package:tutor/model/FilterModel.dart';

class ChooseLocation extends StatelessWidget {
  const ChooseLocation({
    Key? key,
    required this.title,
    required this.placeholder,
    required this.selected,
    this.callback,
  }) : super(key: key);

  final String title;
  final String placeholder;
  final FilterModel selected;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: COLOR.BLUE, width: 0),
        // ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selected.nameTH.isEmpty
                ? Text(
                    placeholder,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  )
                : Text(
                    selected.nameTH,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
