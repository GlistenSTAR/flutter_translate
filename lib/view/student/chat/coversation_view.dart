import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:tutor/model/RecentChatModel.dart';
import 'package:tutor/model/user.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/view/student/chat/chat_page.dart';
import 'package:tutor/widget/conversation_cell.dart';

class ConversationView extends StatelessWidget {
  const ConversationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("StudentIDs")
            .doc(Globals.currentUser!.uid)
            .collection("RecentChats")
            .orderBy("timeStamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemBuilder: (ctx, index) {
                  QueryDocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  data["id"] = document.id;
                  DateTime dateTime =
                      DateTime.parse(data['timeStamp'].toDate().toString());
                  DateFormat formatter = DateFormat("dd/MM/yy");
                  String date = formatter.format(dateTime);
                  formatter = DateFormat("hh:mm");
                  String time = formatter.format(dateTime);
                  data["datetime"] = dateTime;
                  data["date"] = date;
                  data["time"] = time;
                  RecentChatModel model = RecentChatModel.fromJson(data);

                  return ConversationCell(
                    model: model,
                    callback: () async {
                      dynamic result = await showDialog(
                        context: context,
                        builder: (context) => FutureProgressDialog(
                          Util.getTutor(model.userID),
                          message: Text('Please wait for a moment...'),
                        ),
                      );

                      if (result is Map) {
                        User tutor = User(
                          uid: model.userID,
                          isTutor: true,
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

                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ChatPage(
                              requestID: "",
                              roomID: model.id,
                              partner: tutor,
                              location: "",
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (_, __) => Divider(indent: 60),
                itemCount: snapshot.data!.docs.length);
          } else if (snapshot.hasError) {
            return Center(child: Text("Connection Error"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
