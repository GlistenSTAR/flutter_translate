import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/search/filter_plane.dart';
import 'package:tutor/view/student/search/tutor_page.dart';
import 'package:tutor/view/student/search/tutor_time.dart';
import 'package:tutor/widget/profile_card.dart';
import 'package:tutor/widget/search_filter.dart';

class TutorPool extends StatefulWidget {
  TutorPool({Key? key, required this.topicModel}) : super(key: key);

  final TopicModel topicModel;

  @override
  _TutorPoolState createState() => _TutorPoolState();
}

class _TutorPoolState extends State<TutorPool> {
  final teSearch = TextEditingController();
  late List<FilterModel> allLevels, allLocations;
  List<FilterModel> filteredLevels = [], filterLocations = [];

  late bool isSubject;
  late DocumentReference docRef;
  late CollectionReference collectionRef;

  List<TutorCardModel> allTutors = [], filterTutors = [];

  @override
  void initState() {
    super.initState();
    isSubject = widget.topicModel.topic == "subject";
    teSearch.addListener(_onSearch);

    allLevels = FilterModel.getLevelMapping();
    allLocations = FilterModel.getLocationMapping();

    if (isSubject) {
      docRef = FirebaseFirestore.instance
          .collection("Subjects")
          .doc(widget.topicModel.titleID);
      collectionRef = docRef
          .collection("pool_level_x_location_0")
          .doc("all_levels")
          .collection("all_locations");
    } else {
      docRef = FirebaseFirestore.instance
          .collection("Testings")
          .doc(widget.topicModel.titleID);
      collectionRef = docRef.collection("all_location");
    }
  }

  @override
  void dispose() {
    teSearch.removeListener(_onSearch);
    super.dispose();
  }

  void _onSearch() {
    String search = teSearch.text.trim();
    filterTutors = allTutors
        .where((element) =>
            element.nickname.toLowerCase().indexOf(search.toLowerCase()) > -1)
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
        title: Text(widget.topicModel.titleTH),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),

        //#####
        // decoration: BoxDecoration(
        //   shape: BoxShape.rectangle,
        //   boxShadow: [
        //     BoxShadow(
        //         offset: Offset(0, 0),
        //         color: Colors.grey,
        //         spreadRadius: 1,
        //         blurRadius: 2)
        //   ],
        // ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: COLOR.LIGHT_GREY,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: teSearch,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "ค้นหาติวเตอร์",
                  hintStyle: TextStyle(color: COLOR.DARK),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      teSearch.clear();
                    },
                    icon: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.4),
                        radius: 10,
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                isSubject
                    ? Expanded(
                        child: SearchFilter(
                          title: "ระดับชั้น",
                          callback: () async {
                            dynamic result = await Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.black12,
                                pageBuilder: (_, __, ___) => FilterPlane(
                                  title: "ระดับชั้น",
                                  filters: filteredLevels,
                                  models: allLevels,
                                ),
                                transitionsBuilder:
                                    (ctx, anim1, anim2, child) =>
                                        BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 2 * anim1.value,
                                      sigmaY: 2 * anim1.value),
                                  child: FadeTransition(
                                    child: child,
                                    opacity: anim1,
                                  ),
                                ),
                              ),
                            );

                            if (result != null && result is List<FilterModel>) {
                              filteredLevels = result;

                              //Filtering...
                              teSearch.clear();
                              allTutors.clear();
                              setState(() {});
                            }
                          },
                        ),
                      )
                    : Container(),
                isSubject ? SizedBox(width: 8) : Container(),
                Expanded(
                  child: SearchFilter(
                    title: "สถานที่",
                    callback: () async {
                      dynamic result = await Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.black54,
                          pageBuilder: (_, __, ___) => FilterPlane(
                            title: "สถานที่",
                            filters: filterLocations,
                            models: allLocations,
                          ),
                          transitionsBuilder: (ctx, anim1, anim2, child) =>
                              BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 2 * anim1.value,
                                sigmaY: 2 * anim1.value),
                            child: FadeTransition(
                              child: child,
                              opacity: anim1,
                            ),
                          ),
                        ),
                      );

                      if (result != null && result is List<FilterModel>) {
                        filterLocations = result;

                        //Filtering...
                        teSearch.clear();
                        allTutors.clear();
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: allTutors.isEmpty
                  ? FutureBuilder(
                      future: filtering(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          allTutors = snapshot.data as List<TutorCardModel>;
                          filterTutors = allTutors;
                          return _tutorWidget();
                        } else if (snapshot.hasError) {
                          // return snapshot.error;
                          return Container();
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : _tutorWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tutorWidget() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          TutorCardModel model = filterTutors[index];

          return ProfileCard(
            model: model,
            onFavorite: () async {
              DocumentReference tutorRef = FirebaseFirestore.instance
                  .collection("TutorIDs")
                  .doc(model.tutorID)
                  .collection("Information")
                  .doc("Follow");
              DocumentReference studentRef = FirebaseFirestore.instance
                  .collection("StudentIDs")
                  .doc(Globals.currentUser!.uid)
                  .collection("Information")
                  .doc("Follow");
              var batch = FirebaseFirestore.instance.batch();

              if (model.followee.contains(Globals.currentUser!.uid)) {
                batch.set(
                    tutorRef,
                    {
                      "followee":
                          FieldValue.arrayRemove([Globals.currentUser!.uid])
                    },
                    SetOptions(merge: true));
                model.followee.remove(Globals.currentUser!.uid);
                batch.set(
                    studentRef,
                    {
                      "following": FieldValue.arrayRemove([model.tutorID])
                    },
                    SetOptions(merge: true));
                Globals.currentUser!.following.remove(model.tutorID);
              } else {
                model.followee.add(Globals.currentUser!.uid);
                batch.set(tutorRef, {"followee": model.followee},
                    SetOptions(merge: true));
                Globals.currentUser!.following.add(model.tutorID);
                batch.set(
                    studentRef,
                    {"following": Globals.currentUser!.following},
                    SetOptions(merge: true));
              }
              await batch.commit().then((value) {
                setState(() {});
              });
            },
            onView: () {
              //Need to open Tutor's Profile Page
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => TutorPage(model: model),
                ),
              );
            },
            onReserve: () {
              //Tutor Time Table
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => TutorTime(model: model),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 8),
        itemCount: filterTutors.length);
  }

  Future<List<TutorCardModel>> filtering() async {
    List<CollectionReference> collectionList;
    if (isSubject) {
      if (filteredLevels.isEmpty) {
        if (filterLocations.isEmpty) {
          collectionList = [
            docRef
                .collection("pool_level_x_location_0")
                .doc("all_levels")
                .collection("all_locations")
          ];
        } else {
          collectionList = filterLocations
              .map<CollectionReference>((e) => docRef
                  .collection("pool_level_x_location_0")
                  .doc("all_levels")
                  .collection(e.nameID))
              .toList();
        }
      } else {
        if (filterLocations.isEmpty) {
          collectionList = filteredLevels
              .map<CollectionReference>((e) => docRef
                  .collection("pool_level_0_location_0")
                  .doc(e.nameID)
                  .collection("all_locations"))
              .toList();
        } else {
          collectionList = [];
          for (var level in filteredLevels) {
            List<CollectionReference> tempList = filterLocations
                .map<CollectionReference>((e) => docRef
                    .collection("pool_level_0_location_0")
                    .doc(level.nameID)
                    .collection(e.nameID))
                .toList();
            collectionList.addAll(tempList);
          }
        }
      }
    } else {
      if (filterLocations.isEmpty) {
        collectionList = [docRef.collection("all_locations")];
      } else {
        collectionList = filterLocations
            .map<CollectionReference>((e) => docRef.collection(e.nameID))
            .toList();
      }
    }

    List<String> tutorIDs = await getTutorIDs(collectionList);
    List<TutorCardModel> tutors = [];

    for (var uid in tutorIDs) {
      dynamic result = await Util.getTutorProfile(uid);
      if (result is TutorCardModel) {
        tutors.add(result);
      }
    }

    return tutors;
  }

  Future<List<String>> getTutorIDs(
      List<CollectionReference> collections) async {
    List<String> tutorIDs = [];
    for (var collection in collections) {
      QuerySnapshot snapshot = await collection.get();
      List<String> ids = snapshot.docs.map<String>((e) => e.id).toList();
      tutorIDs.addAll(ids);
    }

    //Unique
    tutorIDs = tutorIDs.toSet().toList();
    return tutorIDs;
  }
}
