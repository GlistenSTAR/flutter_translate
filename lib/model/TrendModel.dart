class TrendModel {
  String topic;
  int rank;
  String titleID;
  String imgUrl;

  TrendModel({
    required this.topic,
    required this.rank,
    required this.titleID,
    required this.imgUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'rank': rank,
      'titleID': titleID,
      'imgUrl': imgUrl,
    };
  }

  factory TrendModel.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty)
      return TrendModel(topic: "", rank: 0, titleID: "", imgUrl: "");

    return TrendModel(
      topic: map['topic'] ?? "",
      rank: map['rank'] ?? 0,
      titleID: map['titleID'] ?? "",
      imgUrl: map['imgUrl'] ?? "",
    );
  }

  static List<TrendModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList.map<TrendModel>((obj) => TrendModel.fromJson(obj)).toList();
  }

  static List<TrendModel> getTrendSubject() {
    return [
      TrendModel(
          topic: "subject", rank: 1, titleID: "physics", imgUrl: "physic"),
      TrendModel(
          topic: "subject",
          rank: 2,
          titleID: "chemistry",
          imgUrl: "chemical"),
      TrendModel(
          topic: "subject", rank: 3, titleID: "english", imgUrl: "english"),
      TrendModel(
          topic: "subject", rank: 4, titleID: "german", imgUrl: "german")
    ];
  }
}
