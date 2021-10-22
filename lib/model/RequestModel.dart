class RequestModel {
  String id;
  String name;
  String level;
  String levelTH;
  String subject;

  String startDate;
  String rate;
  String location;
  String locationTH;
  DateTime requestDate;
  String studentID;

  String displayImg;
  String requestStatus;
  bool isBooked;

  RequestModel({
    required this.id,
    required this.name,
    required this.level,
    required this.levelTH,
    required this.subject,
    required this.startDate,
    required this.rate,
    required this.location,
    required this.locationTH,
    required this.requestDate,
    required this.studentID,
    required this.displayImg,
    required this.requestStatus,
    required this.isBooked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'level_th': levelTH,
      'subject': subject,
      'startDate': startDate,
      'rate': rate,
      'location': location,
      'location_th': locationTH,
      'requestDate': requestDate,
      'studentID': studentID,
      'display_img': displayImg,
      'request_status': requestStatus,
      'isBooked': isBooked,
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      level: map['level'] ?? "",
      levelTH: map['level_th'] ?? "",
      subject: map['topic'] ?? "",
      startDate: map['startDate'] ?? "",
      rate: map['rate'] ?? 0,
      location: map['location'] ?? "",
      locationTH: map['location_th'] ?? "",
      requestDate: map['requestDate'] == null
          ? DateTime.now()
          : DateTime.parse(map['requestDate'].toDate().toString()),
      studentID: map['studentID'] ?? "",
      displayImg: map['display_img'] ?? "",
      requestStatus: map['request_status'] ?? "",
      isBooked: map['isBooked'] ?? "",
    );
  }

  static List<RequestModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList
        .map<RequestModel>((obj) => RequestModel.fromJson(obj))
        .toList();
  }
}
