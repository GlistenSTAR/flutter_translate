import 'package:flutter/material.dart';
import 'package:tutor/model/QuizModel.dart';
import 'package:tutor/utils/const.dart';

class QuizSection extends StatefulWidget {
  const QuizSection(
      {Key? key, required this.quizModel, required this.onSelected})
      : super(key: key);

  final QuizModel quizModel;
  final Function(bool) onSelected;

  @override
  _QuizSectionState createState() => _QuizSectionState();
}

class _QuizSectionState extends State<QuizSection> {
  late QuizModel quizModel;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    quizModel = widget.quizModel;
    selectedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quizModel.question,
          style: TextStyle(
            fontFamily: 'Prompt',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              String option = quizModel.options[index];
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onSelected(option == quizModel.answer);
                },
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  primary: Colors.white,
                  onPrimary:
                      (selectedIndex == index) ? COLOR.YELLOW : Colors.black,
                  minimumSize: Size(MediaQuery.of(context).size.width, 40),
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 4),
            itemCount: quizModel.options.length),
      ],
    );
  }
}
