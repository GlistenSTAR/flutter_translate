import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/widget/radio_row.dart';

class ChangeSlot extends StatefulWidget {
  ChangeSlot({Key? key, required this.isAvaliable}) : super(key: key);

  final bool isAvaliable;

  @override
  _ChangeSlotState createState() => _ChangeSlotState();
}

class _ChangeSlotState extends State<ChangeSlot> {
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    isAvailable = widget.isAvaliable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                )),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ระบุสถานะ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //Choose
                        Navigator.of(context).pop(isAvailable);
                      },
                      child: Text(
                        "เลือก",
                        style: TextStyle(
                          color: COLOR.YELLOW,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioRow(
                      title: "ว่าง",
                      selected: isAvailable,
                      callback: () {
                        setState(() {
                          isAvailable = true;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioRow(
                      title: "ไม่ว่าง",
                      selected: !isAvailable,
                      callback: () {
                        setState(() {
                          isAvailable = false;
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
