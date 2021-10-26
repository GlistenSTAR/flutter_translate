import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/RequestModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/model/user.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/chat/chat_page.dart';
import 'package:tutor/view/tutor/home/filter_pop.dart';
import 'package:tutor/widget/search_filter.dart';
import 'package:tutor/widget/thome_card.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<FilterModel> allSubjects, allLocations;
  List<FilterModel> filteredSubjects = [], filterLocations = [];
  List<RequestModel> allRequest = [], filteredRequest = [];

  late CollectionReference collectionRef;

  @override
  void initState() {
    super.initState();

    allSubjects = TopicModel.getSubjects().map<FilterModel>((e) {
      return FilterModel(
          order: e.ord, nameID: e.titleID, nameTH: e.titleTH, checked: false);
    }).toList();
    allLocations = FilterModel.getLocationMapping();

    collectionRef = FirebaseFirestore.instance
        .collection("Application")
        .doc("StudentRequest")
        .collection("AllRequests");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            "งานสอนทั้งหมด",
            style: TextStyle(
              fontFamily: 'Prompt',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: COLOR.YELLOW,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SearchFilter(
                title: "วิชา",
                callback: () async {
                  dynamic result = await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black12,
                      pageBuilder: (_, __, ___) => FilterPop(
                        title: "วิชา",
                        filters: filteredSubjects,
                        models: allSubjects,
                      ),
                      transitionsBuilder: (ctx, anim1, anim2, child) =>
                          BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 2 * anim1.value, sigmaY: 2 * anim1.value),
                        child: FadeTransition(
                          child: child,
                          opacity: anim1,
                        ),
                      ),
                    ),
                  );

                  if (result != null && result is List<FilterModel>) {
                    filteredSubjects = result;
                    filtering();
                  }
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: SearchFilter(
                title: "สถานที่",
                callback: () async {
                  dynamic result = await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black54,
                      pageBuilder: (_, __, ___) => FilterPop(
                        title: "สถานที่",
                        filters: filterLocations,
                        models: allLocations,
                      ),
                      transitionsBuilder: (ctx, anim1, anim2, child) =>
                          BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 2 * anim1.value, sigmaY: 2 * anim1.value),
                        child: FadeTransition(
                          child: child,
                          opacity: anim1,
                        ),
                      ),
                    ),
                  );

                  if (result != null && result is List<FilterModel>) {
                    filterLocations = result;
                    filtering();
                  }
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: allRequest.isEmpty
              ? FutureBuilder<QuerySnapshot>(
                  future: collectionRef.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      allRequest.clear();
                      List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                      for (var document in docs) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        print("------- $data");
                        if (data["request_status"] == "expired" ||
                            data["request_status"] == null) continue;

                        data["id"] = document.id;
                        RequestModel model = RequestModel.fromJson(data);
                        allRequest.add(model);
                      }

                      filteredRequest = allRequest;

                      return _requestList();
                    } else if (snapshot.hasError) {
                      // return snapshot.error;
                      return Container();
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
              : _requestList(),
        ),
      ]),
    );
  }

  Widget _requestList() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          RequestModel model = filteredRequest[index];

          return THomeCard(
            model: model,
            callback: () async {
              // Need to open Tutor's Profile Page

              dynamic result = await showDialog(
                context: context,
                builder: (context) => FutureProgressDialog(
                  Util.getStudent(model.studentID),
                  message: Text('Please wait for a moment...'),
                ),
              );

              if (result is Map) {
                User student = User(
                  uid: model.studentID,
                  isTutor: false,
                  name: result["name"] ?? "",
                  nickname: result["nickname"] ?? "",
                  profileUrl: result["display_img"] ?? "",
                  address: result["address"] ?? "",
                  idCard: result["id_card_filled"] ?? "",
                  following: (result["following"] == null)
                      ? []
                      : (result["following"] as List)
                          .map<String>((e) => e.toString())
                          .toList(),
                );

                String roomID =
                    "${model.studentID}_${Globals.currentUser!.uid}";

                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => ChatPage(
                      requestID: model.id,
                      roomID: roomID,
                      partner: student,
                      location: "",
                    ),
                  ),
                );
              }
            },
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 8),
        itemCount: filteredRequest.length);
  }

  void filtering() {
    setState(() {
      if (filteredSubjects.isEmpty) {
        filteredRequest = allRequest;
      } else {
        filteredRequest = allRequest.where((element) {
          List<FilterModel> temp = filteredSubjects
              .where((e) =>
                  e.nameID.toLowerCase() == element.subject.toLowerCase())
              .toList();
          return temp.isNotEmpty;
        }).toList();
      }

      if (filterLocations.isNotEmpty) {
        filteredRequest = filteredRequest.where((element) {
          List<FilterModel> temp = filterLocations
              .where((e) =>
                  e.nameID.toLowerCase() == element.location.toLowerCase())
              .toList();
          return temp.isNotEmpty;
        }).toList();
      }
    });
  }
}
