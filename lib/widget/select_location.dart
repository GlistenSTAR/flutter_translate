import 'package:flutter/material.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/widget/radio_row.dart';

class SelectLocation extends StatefulWidget {
  SelectLocation({
    Key? key,
    required this.title,
    required this.location,
    required this.models,
  }) : super(key: key);

  final String title;
  final FilterModel location;
  final models;

  @override
  _FilterPlaneState createState() => _FilterPlaneState();
}

class _FilterPlaneState extends State<SelectLocation> {
  late List<FilterModel> models;
  late FilterModel location;

  @override
  void initState() {
    super.initState();
    location = widget.location;
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
            height: models.length * 65,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //Choose
                        Navigator.of(context).pop(location);
                      },
                      child: Text(
                        "เลือก",
                        style: TextStyle(
                          color: COLOR.YELLOW,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView.separated(
                    // physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    // primary: false,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      FilterModel model = models[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RadioRow(
                            title: models[index].nameTH,
                            selected: location == model,
                            callback: () {
                              setState(() {
                                location = model;
                              });
                            }),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemCount: models.length,
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
