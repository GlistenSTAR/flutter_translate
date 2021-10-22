import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/ClassModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/profile/class_detail.dart';
import 'package:tutor/widget/class_card.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({Key? key}) : super(key: key);

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
      body: FutureBuilder(
        future: getClassInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ClassModel> models = snapshot.data as List<ClassModel>;
            return ListView.separated(
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  ClassModel model = models[index];
                  return ClassCard(
                      model: model,
                      callback: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) {
                              return ClassDetail(model: model);
                            },
                          ),
                        );
                      });
                },
                separatorBuilder: (_, __) => SizedBox(height: 8),
                itemCount: models.length);
          } else if (snapshot.hasError) {
            return Center(child: Text("Connection Error"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<ClassModel>> getClassInfo() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("StudentIDs")
        .doc(Globals.currentUser!.uid)
        .collection("Classes")
        .get();

    List<String> ids = snapshot.docs.map<String>((e) => e.id).toList();
    List<ClassModel> models = [];
    for (var id in ids) {
      ClassModel model = await getClass(id);
      models.add(model);
    }

    return models;
  }

  Future<ClassModel> getClass(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("ClassIDs").doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data['id'] = id;

    dynamic tutor = await Util.getTutor(data['tutor_id']);
    if (tutor is Map) {
      data['tutor_nickname'] = tutor["nickname"];
      data['tutor_name'] = tutor["name"];
      data['tutor_address'] = tutor["address"];
    }

    String status;
    switch (data["class_status"] ?? "") {
      case "00":
        status = "จองแล้ว";
        break;
      case "pending":
        status = "รอการจ่ายเงิน";
        break;
      case "done":
        status = "สอนเสร็จ";
        break;
      default:
        status = "รอการยืนยันการเรียน";
        break;
    }
    data["status"] = status;
    data["location"] = Util.locationTH(data["location"] ?? "");
    data["status_changed"] = data["status_changed"] ?? false;
    return ClassModel.fromJson(data);
  }
}
