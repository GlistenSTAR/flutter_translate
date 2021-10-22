import 'package:intl/intl.dart';
import 'package:tutor/utils/util.dart';

class ClassModel {
  String id;
  String title;
  String tutorID;
  String tutorNickname;
  String tutorName;
  String tutorAddress;
  String studentID;
  String studentNickname;
  String studentName;
  String studentAddress;
  String status;
  String beginTime;
  String date;
  String endTime;
  String time;
  String location;
  bool statusChanged;
  DateTime? begin;
  DateTime? end;
  Map<String, dynamic>? previous;

  ClassModel({
    required this.id,
    required this.title,
    required this.tutorID,
    required this.tutorNickname,
    required this.tutorName,
    required this.tutorAddress,
    required this.studentID,
    required this.studentNickname,
    required this.studentName,
    required this.studentAddress,
    required this.status,
    required this.beginTime,
    required this.date,
    required this.endTime,
    required this.time,
    required this.location,
    required this.statusChanged,
    this.begin,
    this.end,
    this.previous,
  });

  factory ClassModel.fromJson(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'],
      title: map['class_title'] ?? "",
      tutorID: map['tutor_id'] ?? "",
      tutorNickname: map['tutor_nickname'] ?? "",
      tutorName: map['tutor_name'] ?? "",
      tutorAddress: map['tutor_address'] ?? "",
      studentID: map['student_id'] ?? "",
      studentNickname: map['student_nickname'] ?? "",
      studentName: map['student_name'] ?? "",
      studentAddress: map['student_address'] ?? "",
      status: map['status'] ?? "",
      beginTime: map['class_beginTime'] ?? "",
      date: map['class_date'] ?? "",
      // date: DateFormat("dd/MM/yyyy")
      //     .format(Util.toBuddhist(
      //         DateFormat("yyyy-MM-dd").parse(map['class_date'].toString())))
      //     .toString(),
      endTime: map['class_endTime'] ?? "",
      time: map['class_time'] ?? "",
      location: map['location'] ?? "",
      statusChanged: map['status_changed'] ?? true,
      previous: map['previous'],
    );
  }
}
