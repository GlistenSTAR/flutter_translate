import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor/model/RequestModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';

class THomeCard extends StatelessWidget {
  const THomeCard({Key? key, required this.model, this.callback})
      : super(key: key);

  final RequestModel model;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    Duration duration = DateTime.now().difference(model.requestDate);
    bool isNewRequest = duration.inDays == 0;
    bool isBooked = model.requestStatus != "" && model.requestStatus != "live";

    TopicModel topicModel = TopicModel.getSubjects()
        .firstWhere((element) => element.titleID == model.subject);

    return InkWell(
      onTap: callback,
      child: Card(
        borderOnForeground: true,
        shape: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: Colors.white)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 3)
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0),
                    color: Colors.white,
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            model.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isNewRequest)
                          Text(
                            " NEW",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "วันที่รีเควส",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ระดับชั้น: ${Util.gradeTH(model.level)}"),
                          Text("วิชา: ${topicModel.longNameTH}"),
                          Row(
                            children: [
                              Text(
                                  "วันที่เริ่มเรียน: ${formatedDateString(model.startDate)}"),
                              Spacer(),
                              Text(Util.formatedStringFrom(model.requestDate)),
                              Spacer(),
                            ],
                          ),
                          Text("เรทต่อชั่วโมง: ${model.rate}"),
                          Text("สถานที่: ${model.locationTH}"),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isBooked
                            ? Colors.grey.shade300
                            : Colors.green.shade50,
                      ),
                      child: Text(
                        isBooked ? "จองแล้ว" : "ว่าง",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isBooked
                              ? Colors.black
                              : Color.fromRGBO(119, 175, 135, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatedDateString(String strDate) {
    try {
      DateFormat format = DateFormat("dd MMM yyyy", "en");
      DateTime date = format.parse(strDate);
      format = DateFormat("dd/MM/yy");
      return format.format(Util.toBuddhist(date));
    } catch (e) {
      print(e);
      return "";
    }
  }
}
