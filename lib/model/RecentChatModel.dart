class RecentChatModel {
  String id;
  String userID;
  String nickname;
  String displayImg;
  String lastMsg;
  DateTime datetime;
  String date;
  String time;
  
  RecentChatModel({
    required this.id,
    required this.userID,
    required this.nickname,
    required this.displayImg,
    required this.lastMsg,
    required this.datetime,
    required this.date,
    required this.time,    
  });

  factory RecentChatModel.fromJson(Map<String, dynamic> map) {
    
    return RecentChatModel(
      id: map['id'],
      userID: map['user_id'] ?? 0,
      nickname: map['nickname'] ?? "",
      displayImg: map['display_img'] ?? "",
      lastMsg: map['last_msg'] ?? "",
      datetime: map['datetime'],
      date: map['date'],
      time: map['time'],
    );
  }
}
