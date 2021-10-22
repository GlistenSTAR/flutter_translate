class StringsModel {
  String stringID;
  String stringTH;

  StringsModel({
    required this.stringID,
    required this.stringTH,
  });

  Map<String, dynamic> toJson() {
    return {
      'titleID': stringID,
      'titleTH': stringTH,
    };
  }

  factory StringsModel.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty)
      return StringsModel(
        stringID: "",
        stringTH: "",
      );

    return StringsModel(
      stringID: map['stringID'] ?? "",
      stringTH: map['stringTH'] ?? "",
    );
  }

  static List<StringsModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList
        .map<StringsModel>((obj) => StringsModel.fromJson(obj))
        .toList();
  }

  static List<StringsModel> getGenders() {
    return [
      StringsModel(
        stringID: "female",
        stringTH: "หญิง",
      ),
      StringsModel(
        stringID: "male",
        stringTH: "ชาย",
      ),
      StringsModel(
        stringID: "lgbt",
        stringTH: "เพศทางเลือก",
      ),
    ];
  }

  static List<StringsModel> getYears() {
    return [
      StringsModel(
        stringID: "Less 1",
        stringTH: "น้อยกว่า 1 ปี",
      ),
      StringsModel(
        stringID: "1",
        stringTH: "1 ปี",
      ),
      StringsModel(
        stringID: "2",
        stringTH: "2 ปี",
      ),
      StringsModel(
        stringID: "3",
        stringTH: "3 ปี",
      ),
      StringsModel(
        stringID: "4",
        stringTH: "4 ปี",
      ),
      StringsModel(
        stringID: "5",
        stringTH: "5 ปี",
      ),
      StringsModel(
        stringID: "6",
        stringTH: "6 ปี",
      ),
      StringsModel(
        stringID: "7",
        stringTH: "7 ปี",
      ),
      StringsModel(
        stringID: "8",
        stringTH: "8 ปี",
      ),
      StringsModel(
        stringID: "9",
        stringTH: "9 ปี",
      ),
      StringsModel(
        stringID: "10",
        stringTH: "10 ปี",
      ),
      StringsModel(
        stringID: "more 10",
        stringTH: "มากกว่า 10 ปี",
      ),
    ];
  }
}
