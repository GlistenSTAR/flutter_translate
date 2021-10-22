class User {
  String uid;
  bool isTutor;
  String nickname;
  String name;
  String profileUrl;
  String address;
  List<String> following;
  String idCard;

  User({
    required this.uid,
    required this.isTutor,
    required this.nickname,
    required this.name,
    required this.profileUrl,
    required this.address,
    required this.following,
    required this.idCard,
  });
}
