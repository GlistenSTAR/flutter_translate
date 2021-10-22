import 'package:flutter/material.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/StringsModel.dart';

class ChooseString extends StatelessWidget {
  const ChooseString({
    Key? key,
    required this.placeholder,
    required this.selected,
    this.callback,
  }) : super(key: key);

  final String placeholder;
  final StringsModel selected;
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
            selected.stringTH.isEmpty
                ? Text(
                    placeholder,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  )
                : Text(
                    selected.stringTH,
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
