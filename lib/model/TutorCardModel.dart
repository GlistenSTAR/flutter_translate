class TutorCardModel {
  String tutorID;
  String nickname;
  String name;
  String profileUrl;
  String degree;
  String study;
  String school;
  String teachYear;
  String rate;
  List<String> locations;
  Map<String, dynamic> subjectLevels;
  List<String> subjectTHs;
  List<String> testings;
  String promo;

  //I follow them
  // List<String> following;

  //They follow me
  List<String> followee;

  TutorCardModel({
    required this.tutorID,
    required this.nickname,
    required this.name,
    required this.profileUrl,
    required this.degree,
    required this.study,
    required this.school,
    required this.teachYear,
    required this.rate,
    required this.locations,
    required this.subjectLevels,
    required this.subjectTHs,
    required this.testings,
    required this.promo,
    // required this.following,
    required this.followee,
  });
}
