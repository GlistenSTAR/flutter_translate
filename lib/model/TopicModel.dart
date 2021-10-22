class TopicModel {
  String topic;
  int ord;
  String titleID;
  String titleTH;
  String longNameTH;
  String iconName;

  TopicModel({
    required this.topic,
    required this.ord,
    required this.titleID,
    required this.titleTH,
    required this.longNameTH,
    required this.iconName,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'ord': ord,
      'titleID': titleID,
      'titleTH': titleTH,
      'longNameTH': longNameTH,
      'iconName': iconName,
    };
  }

  factory TopicModel.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty)
      return TopicModel(
          topic: "",
          ord: 0,
          titleID: "",
          titleTH: "",
          longNameTH: "",
          iconName: "");

    return TopicModel(
      topic: map['topic'] ?? "",
      ord: map['ord'] ?? 0,
      titleID: map['titleID'] ?? "",
      titleTH: map['titleTH'] ?? "",
      longNameTH: map['longNameTH'] ?? "",
      iconName: map['iconName'] ?? "",
    );
  }

  static List<TopicModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList.map<TopicModel>((obj) => TopicModel.fromJson(obj)).toList();
  }

  // math, chemistry, biology, physics, korean, social, art, french
  static List<TopicModel> getHomeSubject() {
    return [
      TopicModel(
          topic: "subject",
          ord: 0,
          titleID: "math",
          titleTH: "คณิต",
          longNameTH: "คณิต",
          iconName: "icon-math"),
      TopicModel(
          topic: "subject",
          ord: 1,
          titleID: "chemistry",
          titleTH: "เคมี",
          longNameTH: "เคมี",
          iconName: "icon-chemistry"),
      TopicModel(
          topic: "subject",
          ord: 2,
          titleID: "bio",
          titleTH: "ชีวะ",
          longNameTH: "ชีววิทยา",
          iconName: "icon-bio"),
      TopicModel(
          topic: "subject",
          ord: 3,
          titleID: "physics",
          titleTH: "ฟิสิกส์",
          longNameTH: "ฟิสิกส์",
          iconName: "icon-physic"),
      TopicModel(
          topic: "subject",
          ord: 4,
          titleID: "korean",
          titleTH: "เกาหลี",
          longNameTH: "ภาษาเกาหลี",
          iconName: "icon-korean"),
      TopicModel(
          topic: "subject",
          ord: 5,
          titleID: "social",
          titleTH: "สังคม",
          longNameTH: "สังคมศึกษา",
          iconName: "icon-social"),
      TopicModel(
          topic: "subject",
          ord: 6,
          titleID: "art",
          titleTH: "ศิลปะ",
          longNameTH: "ศิลปะ",
          iconName: "icon-art"),
      TopicModel(
          topic: "subject",
          ord: 7,
          titleID: "french",
          titleTH: "ฝรั่งเศส",
          longNameTH: "ภาษาฝรั่งเศส",
          iconName: "icon-french"),
    ];
  }

  static List<TopicModel> getSubjects() {
    return [
      TopicModel(
          topic: "subject",
          ord: 0,
          titleID: "math",
          titleTH: "คณิต",
          longNameTH: "คณิตศาตร์",
          iconName: "icon-math"),
      TopicModel(
          topic: "subject",
          ord: 1,
          titleID: "chemistry",
          titleTH: "เคมี",
          longNameTH: "เคมี",
          iconName: "icon-chemistry"),
      TopicModel(
          topic: "subject",
          ord: 2,
          titleID: "bio",
          titleTH: "ชีวะ",
          longNameTH: "ชีววิทยา",
          iconName: "icon-bio"),
      TopicModel(
          topic: "subject",
          ord: 3,
          titleID: "physics",
          titleTH: "ฟิสิกส์",
          longNameTH: "ฟิสิกส์",
          iconName: "icon-physic"),
      TopicModel(
          topic: "subject",
          ord: 4,
          titleID: "korean",
          titleTH: "เกาหลี",
          longNameTH: "ภาษาเกาหลี",
          iconName: "icon-korean"),
      TopicModel(
          topic: "subject",
          ord: 5,
          titleID: "chinese",
          titleTH: "จีน",
          longNameTH: "ภาษาจีน",
          iconName: "icon-chinese"),
      TopicModel(
          topic: "subject",
          ord: 6,
          titleID: "japanese",
          titleTH: "ญี่ปุ่น",
          longNameTH: "ภาษาญี่ปุ่น",
          iconName: "icon-japanese"),
      TopicModel(
          topic: "subject",
          ord: 7,
          titleID: "thai",
          titleTH: "ไทย",
          longNameTH: "ภาษาไทย",
          iconName: "icon-thai"),
      TopicModel(
          topic: "subject",
          ord: 8,
          titleID: "french",
          titleTH: "ฝรั่งเศส",
          longNameTH: "ภาษาฝรั่งเศส",
          iconName: "icon-french"),
      TopicModel(
          topic: "subject",
          ord: 9,
          titleID: "german",
          titleTH: "เยอรมัน",
          longNameTH: "ภาษาเยอรมัน",
          iconName: "icon-german"),
      TopicModel(
          topic: "subject",
          ord: 10,
          titleID: "russian",
          titleTH: "รัสเซีย",
          longNameTH: "ภาษารัสเซีย",
          iconName: "icon-russian"),
      TopicModel(
          topic: "subject",
          ord: 11,
          titleID: "spanish",
          titleTH: "สเปน",
          longNameTH: "ภาษาสเปน",
          iconName: "icon-spanish"),
      TopicModel(
          topic: "subject",
          ord: 12,
          titleID: "eng",
          titleTH: "อังกฤษ",
          longNameTH: "ภาษาอังกฤษ",
          iconName: "icon-english"),
      TopicModel(
          topic: "subject",
          ord: 13,
          titleID: "science",
          titleTH: "วิทย์",
          longNameTH: "วิทยาศาสตร์",
          iconName: "icon-science"),
      TopicModel(
          topic: "subject",
          ord: 14,
          titleID: "art",
          titleTH: "ศิลปะ",
          longNameTH: "ศิลปะ",
          iconName: "icon-art"),
      TopicModel(
          topic: "subject",
          ord: 15,
          titleID: "social",
          titleTH: "สังคม",
          longNameTH: "สังคมศึกษา",
          iconName: "icon-social"),
      TopicModel(
          topic: "subject",
          ord: 14,
          titleID: "3rd",
          titleTH: "ภาษาอื่นๆ",
          longNameTH: "ภาษาที่ 3 อื่นๆ",
          iconName: "icon-3rd"),
      TopicModel(
          topic: "subject",
          ord: 15,
          titleID: "others",
          titleTH: "อื่นๆ",
          longNameTH: "อื่นๆ",
          iconName: "icon-others")
    ];
  }

  static List<TopicModel> getHomeTest() {
    return [
      TopicModel(
          topic: "testing",
          ord: 0,
          titleID: "toeic",
          titleTH: "TOEIC",
          longNameTH: "TOEIC",
          iconName: "icon-testing-toeic"),
      TopicModel(
          topic: "testing",
          ord: 1,
          titleID: "topik",
          titleTH: "TOPIK",
          longNameTH: "TOPIK",
          iconName: "icon-testing-topik"),
      TopicModel(
          topic: "testing",
          ord: 2,
          titleID: "pat1_math",
          titleTH: "คณิต",
          longNameTH: "PAT1 (คณิต)",
          iconName: "icon-testing-pat1_math"),
      TopicModel(
          topic: "testing",
          ord: 3,
          titleID: "gat2_eng",
          titleTH: "อังกฤษ",
          longNameTH: "9 วิชา (สังคม)",
          iconName: "icon-testing-gat2_eng"),
      TopicModel(
          topic: "testing",
          ord: 4,
          titleID: "pat7_3",
          titleTH: "ญี่ปุ่น",
          longNameTH: "PAT7.3 (ญี่ปุ่น)",
          iconName: "icon-testing-pat7_3"),
      TopicModel(
          topic: "testing",
          ord: 5,
          titleID: "ielts",
          titleTH: "IELTS",
          longNameTH: "IELTS",
          iconName: "icon-testing-ielts"),
      TopicModel(
          topic: "testing",
          ord: 6,
          titleID: "tu_get",
          titleTH: "TU-GET",
          longNameTH: "TU-GET",
          iconName: "icon-testing-tu_get"),
      TopicModel(
          topic: "testing",
          ord: 7,
          titleID: "sat",
          titleTH: "SAT",
          longNameTH: "SAT",
          iconName: "icon-testing-sat")
    ];
  }

  static List<TopicModel> getTests() {
    return [
      TopicModel(
          topic: "testing",
          ord: 0,
          titleID: "9vi_math1",
          titleTH: "คณิต1 1",
          longNameTH: "9 วิชา (คณิต1)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 1,
          titleID: "9vi_math2",
          titleTH: "คณิต1 2",
          longNameTH: "9 วิชา (คณิต2)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 2,
          titleID: "9vi_chem",
          titleTH: "เคมี",
          longNameTH: "9 วิชา (เคมี)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 3,
          titleID: "9vi_bio",
          titleTH: "ชีวะ",
          longNameTH: "9 วิชา (ชีวะ)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 4,
          titleID: "9vi_thai",
          titleTH: "ไทย",
          longNameTH: "9 วิชา (ไทย)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 5,
          titleID: "9vi_physic",
          titleTH: "ฟิสิกส์",
          longNameTH: "9 วิชา (ฟิสิกส์)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 6,
          titleID: "9vi_sci",
          titleTH: "วิทย์ทั่วไป",
          longNameTH: "9 วิชา (วิทย์ทั่วไป)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 7,
          titleID: "9vi_social",
          titleTH: "สังคม",
          longNameTH: "9 วิชา (สังคม)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 8,
          titleID: "9vi_eng",
          titleTH: "อังกฤษ",
          longNameTH: "9 วิชา (อังกฤษ)",
          iconName: "icon-testing-9vi"),
      TopicModel(
          topic: "testing",
          ord: 9,
          titleID: "cu_tep",
          titleTH: "CU-TEP",
          longNameTH: "CU-TEP",
          iconName: "icon-testing-cu_tep"),
      TopicModel(
          topic: "testing",
          ord: 10,
          titleID: "gat1_thai",
          titleTH: "ไทย",
          longNameTH: "GAT 1 (ไทย)",
          iconName: "icon-testing-gat1_thai"),
      TopicModel(
          topic: "testing",
          ord: 11,
          titleID: "gat2_eng",
          titleTH: "อังกฤษ",
          longNameTH: "GAT 2 (อังกฤษ)",
          iconName: "icon-testing-gat2_eng"),
      TopicModel(
          topic: "testing",
          ord: 12,
          titleID: "hsk",
          titleTH: "HSK",
          longNameTH: "HSK",
          iconName: "icon-testing-hsk"),
      TopicModel(
          topic: "testing",
          ord: 13,
          titleID: "ielts",
          titleTH: "IELTS",
          longNameTH: "IELTS",
          iconName: "icon-testing-ielts"),
      TopicModel(
          topic: "testing",
          ord: 14,
          titleID: "jlpt",
          titleTH: "JLPT",
          longNameTH: "JLPT",
          iconName: "icon-testing-jlpt"),
      TopicModel(
          topic: "testing",
          ord: 15,
          titleID: "onet",
          titleTH: "O-net",
          longNameTH: "O-net",
          iconName: "icon-testing-onet"),
      TopicModel(
          topic: "testing",
          ord: 16,
          titleID: "pat1_math",
          titleTH: "คณิต",
          longNameTH: "PAT 1 (คณิต)",
          iconName: "icon-testing-pat1_math"),
      TopicModel(
          topic: "testing",
          ord: 17,
          titleID: "pat2_chem",
          titleTH: "เคมี",
          longNameTH: "PAT 2 (เคมี)",
          iconName: "icon-testing-pat2"),
      TopicModel(
          topic: "testing",
          ord: 18,
          titleID: "pat2_bio",
          titleTH: "ชีวะ",
          longNameTH: "PAT 2 (ชีวะ)",
          iconName: "icon-testing-pat2"),
      TopicModel(
          topic: "testing",
          ord: 19,
          titleID: "pat2_physic",
          titleTH: "ฟิสิกส์",
          longNameTH: "PAT 2 (ฟิสิกส์)",
          iconName: "icon-testing-pat2"),
      TopicModel(
          topic: "testing",
          ord: 20,
          titleID: "pat3",
          titleTH: "วิศวะ",
          longNameTH: "PAT 3 (วิศวะ)",
          iconName: "icon-testing-pat3"),
      TopicModel(
          topic: "testing",
          ord: 21,
          titleID: "pat4",
          titleTH: "สถาปัต",
          longNameTH: "PAT 4 (สถาปัต)",
          iconName: "icon-testing-pat4"),
      TopicModel(
          topic: "testing",
          ord: 22,
          titleID: "pat5",
          titleTH: "ครู",
          longNameTH: "PAT 5 (ครู)",
          iconName: "icon-testing-pat5"),
      TopicModel(
          topic: "testing",
          ord: 23,
          titleID: "pat6",
          titleTH: "ศิลปะ",
          longNameTH: "PAT 6 (ศิลปะ)",
          iconName: "icon-testing-pat6"),
      TopicModel(
          topic: "testing",
          ord: 24,
          titleID: "pat7_1",
          titleTH: "ฝรั่งเศส",
          longNameTH: "PAT 7.1 (ฝรั่งเศส)",
          iconName: "icon-testing-pat7_1"),
      TopicModel(
          topic: "testing",
          ord: 25,
          titleID: "pat7_2",
          titleTH: "เยอรมัน",
          longNameTH: "PAT 7.2 (เยอรมัน)",
          iconName: "icon-testing-pat7_2"),
      TopicModel(
          topic: "testing",
          ord: 26,
          titleID: "pat7_3",
          titleTH: "ญี่ปุ่น",
          longNameTH: "PAT 7.3 (ญี่ปุ่น)",
          iconName: "icon-testing-pat7_3"),
      TopicModel(
          topic: "testing",
          ord: 27,
          titleID: "pat7_4",
          titleTH: "จีน",
          longNameTH: "PAT 7.4 (จีน)",
          iconName: "icon-testing-pat7_4"),
      TopicModel(
          topic: "testing",
          ord: 28,
          titleID: "pat7_5",
          titleTH: "อาหรับ",
          longNameTH: "PAT 7.5 (อาหรับ)",
          iconName: "icon-testing-pat7_5"),
      TopicModel(
          topic: "testing",
          ord: 29,
          titleID: "pat7_6",
          titleTH: "บาลี",
          longNameTH: "PAT 7.6 (บาลี)",
          iconName: "icon-testing-pat7_6"),
      TopicModel(
          topic: "testing",
          ord: 30,
          titleID: "pat7_7",
          titleTH: "เกาหลี",
          longNameTH: "PAT 7.7 (เกาหลี)",
          iconName: "icon-testing-pat7_7"),
      TopicModel(
          topic: "testing",
          ord: 31,
          titleID: "sat",
          titleTH: "SAT",
          longNameTH: "SAT",
          iconName: "icon-testing-sat"),
      TopicModel(
          topic: "testing",
          ord: 32,
          titleID: "toefl",
          titleTH: "TOEFL",
          longNameTH: "TOEFL",
          iconName: "icon-testing-toefl"),
      TopicModel(
          topic: "testing",
          ord: 33,
          titleID: "toeic",
          titleTH: "TOEIC",
          longNameTH: "TOEIC",
          iconName: "icon-testing-toeic"),
      TopicModel(
          topic: "testing",
          ord: 34,
          titleID: "topik",
          titleTH: "TOPIK",
          longNameTH: "TOPIK",
          iconName: "icon-testing-topik"),
      TopicModel(
          topic: "testing",
          ord: 35,
          titleID: "tu_get",
          titleTH: "TU-GET",
          longNameTH: "TU-GET",
          iconName: "icon-testing-tu_get"),
      TopicModel(
          topic: "testing",
          ord: 36,
          titleID: "others",
          titleTH: "อื่นๆ",
          longNameTH: "อื่นๆ",
          iconName: "icon-testing-others")
    ];
  }
}
