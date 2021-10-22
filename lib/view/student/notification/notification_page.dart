import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/NotificationModel.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/widget/notification_cell.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late CollectionReference collectionRef;

  @override
  void initState() {
    super.initState();

    if (Globals.currentUser!.isTutor) {
      collectionRef = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(Globals.currentUser!.uid)
          .collection("GeneralNotifications");
    } else {
      collectionRef = FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(Globals.currentUser!.uid)
          .collection("GeneralNotifications");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "แจ้งเตือน",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 12,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child:
                    // Center(child: Text("ไม่มีการแจ้งเตือน", style: TextStyle(fontSize: 18),),),
                    FutureBuilder<QuerySnapshot>(
                        future: collectionRef.orderBy("time_sent").get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<NotificationModel> notifications =
                                snapshot.data!.docs.map<NotificationModel>((e) {
                              Map<String, dynamic> data =
                                  e.data() as Map<String, dynamic>;
                              data["id"] = e.id;
                              return NotificationModel.fromJson(data);
                            }).toList();

                            if (notifications.isEmpty) {
                              return Center(
                                child: Text(
                                  "ไม่มีการแจ้งเตือน",
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            } else {
                              return ListView.separated(
                                  itemBuilder: (context, index) {
                                    NotificationModel notification =
                                        notifications[index];

                                    if (!notification.isReaded) {
                                      markAsRead(notification.id);
                                    }

                                    return NotificationCell(
                                      notification: notification,
                                      callback: () {},
                                    );
                                  },
                                  separatorBuilder: (_, __) => Divider(),
                                  itemCount: 10);
                            }
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Connection Error"));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void markAsRead(String id) async {
    Map<String, dynamic> data = {"is_readed": true};
    await collectionRef.doc(id).set(data, SetOptions(merge: true));
  }
}
