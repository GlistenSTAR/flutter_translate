import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/StringsModel.dart';
import 'package:tutor/utils/const.dart';

class SelectString extends StatefulWidget {
  SelectString({
    Key? key,
    required this.title,
    required this.selected,
    required this.models,
  }) : super(key: key);

  final String title;
  final StringsModel selected;
  final List<StringsModel> models;

  @override
  _SelectStringState createState() => _SelectStringState();
}

class _SelectStringState extends State<SelectString> {
  late List<StringsModel> models;
  late StringsModel selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
    models = widget.models;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Flexible(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            height: (models.length + 2) * 50,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      StringsModel model = models[index];
                      return Container(
                          padding: const EdgeInsets.only(top: 3, bottom: 3),
                          child: Column(
                            children: [
                              new GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(model);
                                },
                                child: new Text(
                                  model.stringTH,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Prompt',
                                      color: widget.selected.stringID ==
                                              model.stringID
                                          ? COLOR.YELLOW
                                          : COLOR.BLACK),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Color.fromRGBO(198, 198, 198, 1),
                              ),
                            ],
                          ));
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 0),
                    itemCount: models.length,
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text(
                    "ปิด",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
