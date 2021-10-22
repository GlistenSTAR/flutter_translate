class QuizModel {
  String question;
  String answer;
  int ord;
  List<String> options;

  QuizModel({
    required this.question,
    required this.answer,
    required this.ord,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'ord': ord,
      'options': options,
    };
  }

  factory QuizModel.fromJson(Map<String, dynamic> map) {
    if (map.isEmpty)
      return QuizModel(question: "", answer: "", ord: 0, options: []);

    return QuizModel(
        question: map['question'] ?? "",
        answer: map['answer'] ?? "",
        ord: map['ord'] ?? 0,
        options: [
          map['a'] ?? "",
          map['b'] ?? "",
          map['c'] ?? "",
          map['d'] ?? "",
        ]);
  }

  static List<QuizModel> fromJsonList(jsonList) {
    if (jsonList == null) return [];
    return jsonList.map<QuizModel>((obj) => QuizModel.fromJson(obj)).toList();
  }
}
