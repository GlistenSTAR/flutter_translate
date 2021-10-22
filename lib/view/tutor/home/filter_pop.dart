import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/widget/radio_row.dart';

class FilterPop extends StatefulWidget {
  FilterPop({
    Key? key,
    required this.title,
    required this.filters,
    required this.models,
  }) : super(key: key);

  final String title;
  final List<FilterModel> filters, models;

  @override
  _FilterPopState createState() => _FilterPopState();
}

class _FilterPopState extends State<FilterPop> {
  late List<FilterModel> filters, models;

  @override
  void initState() {
    super.initState();
    filters = widget.filters;
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //Choose
                    Navigator.of(context).pop(filters);
                  },
                  child: Text(
                    "เลือก",
                    style: TextStyle(
                      fontFamily: 'Prompt',
                      color: COLOR.YELLOW,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .55),
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      FilterModel model = models[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RadioRow(
                            title: models[index].nameTH,
                            selected: filters.contains(model),
                            callback: () {
                              setState(() {
                                if (filters.contains(model)) {
                                  filters.remove(model);
                                } else {
                                  filters.add(model);
                                }
                              });
                            }),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemCount: models.length,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
