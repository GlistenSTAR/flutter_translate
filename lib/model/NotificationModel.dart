import 'package:intl/intl.dart';
import 'package:tutor/utils/util.dart';

class NotificationModel {
  String id;
  String type;
  String title;
  String message;
  DateTime timeSent;
  bool isReaded;
  String imageUrl;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timeSent,
    required this.isReaded,
    required this.imageUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      type: map['type'] ?? "",
      title: map['title'] ?? "",
      message: map['message'] ?? "",
      timeSent: map['time_sent'] == null
          ? DateTime.now()
          : DateTime.parse(map['time_sent'].toDate().toString()),
      isReaded: map['is_readed'] ?? false,
      imageUrl: map['image_url'] ?? "",
    );
  }

  String displayTime() {
    Duration duration = DateTime.now().difference(this.timeSent);
    String time = "";
    if (duration.inHours < 1) {
      time = "${duration.inMinutes}  นาทีที่แล้ว";
    } else if (duration.inHours < 24) {
      time = "${duration.inHours}  ชั่วโมงที่แล้ว";
    } else if (duration.inDays < 2) {
      time = "เมื่อวาน";
    } else {
      DateFormat formatter = DateFormat("dd/MM/yy");
      time = formatter.format(Util.toBuddhist(this.timeSent));
    }
    return time;
  }
}
