import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class SubjectSwitch extends StatelessWidget {
  SubjectSwitch({
    Key? key,
    required this.isSubject,
    this.onSubject,
    this.onTest,
  }) : super(key: key);

  final bool isSubject;
  final VoidCallback? onSubject, onTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: COLOR.BLUE,
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onSubject,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: isSubject ? Colors.white : null,
                ),
                child: Text(
                  "วิชา",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: isSubject ? FontWeight.bold : FontWeight.normal,
                    color: isSubject ? COLOR.BLUE : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onTest,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: isSubject ? null : Colors.white,
                ),
                child: Text(
                  "ติวสอบ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: isSubject ? FontWeight.normal : FontWeight.bold,
                    color: isSubject ? Colors.white : COLOR.BLUE,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
