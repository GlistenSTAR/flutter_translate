import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/widget/radio_row.dart';

class TeachLocation extends StatefulWidget {
  TeachLocation({Key? key, required this.info}) : super(key: key);

  final Map<String, dynamic> info;

  @override
  _TeachLocationState createState() => _TeachLocationState();
}

class _TeachLocationState extends State<TeachLocation> {
  List<FilterModel> allLocations = FilterModel.getLocationMapping();
  late List<FilterModel> myLocations;

  @override
  void initState() {
    super.initState();

    List locations = widget.info["locations"] ?? [];

    myLocations = locations
        .map<FilterModel>(
          (e) => allLocations.firstWhere((element) =>
              (element.nameID == e.toString() ||
                  element.nameTH == e.toString())),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: COLOR.YELLOW,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "เลือกสถานที่สอน",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  FilterModel location = allLocations[index];

                  return RadioRow(
                      title: allLocations[index].nameTH,
                      selected: myLocations.contains(location),
                      callback: () {
                        setState(() {
                          if (myLocations.contains(location)) {
                            myLocations.remove(location);
                          } else {
                            myLocations.add(location);
                          }
                        });
                      });
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: allLocations.length,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                updateInfo();
              },
              child: Text(
                "บันทึก",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                primary: COLOR.YELLOW,
                onPrimary: Colors.white,
                minimumSize: Size(MediaQuery.of(context).size.width, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateInfo() async {
    List<String> locations = myLocations.map<String>((e) => e.nameID).toList();

    Map<String, dynamic> data = {"locations": locations};

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.deleteTutorFromSubjectPool(
            Globals.currentUser!.uid,
            widget.info["subject_levels"] ?? {},
            widget.info["locations"] ?? []),
        message: Text('Please wait for a moment...'),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.deleteTutorFromTestingPool(Globals.currentUser!.uid,
            widget.info["testings"] ?? [], widget.info["locations"] ?? []),
        message: Text('Please wait for a moment...'),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.addTutorToSubjectPool(Globals.currentUser!.uid,
            widget.info["subject_levels"] ?? {}, locations),
        message: Text('Please wait for a moment...'),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.addTutorToTestingPool(
            Globals.currentUser!.uid, widget.info["testings"] ?? [], locations),
        message: Text('Please wait for a moment...'),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.updateTeachLocation(Globals.currentUser!.uid, data),
        message: Text('Please wait for a moment...'),
      ),
    );

    Navigator.of(context).pop(data);
  }
}
