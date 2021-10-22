class MessageModel {
  String id;
  String msg;
  String image;
  String userID;
  DateTime timeStamp;

  MessageModel({
    required this.id,
    required this.msg,
    required this.image,
    required this.userID,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'msg': msg,
      'image': image,
      'user': userID,
      'timeStamp': timeStamp,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? "",
      msg: map['msg'] ?? "",
      image: map['image'] ?? "",
      userID: map['user'] ?? "",
      timeStamp: map['timeStamp'] == null
          ? DateTime.now()
          : DateTime.parse(map['timeStamp'].toDate().toString()),
    );
  }

  static List<MessageModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList
        .map<MessageModel>((obj) => MessageModel.fromJson(obj))
        .toList();
  }
}
