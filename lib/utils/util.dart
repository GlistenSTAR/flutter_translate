import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/globals.dart';

class Util {
  static String getBuddhistCalendarYear(DateTime date) {
    return (date.year + 543).toString();
  }

  static String getBuddhistDate(DateTime date) {
    DateFormat formatter = DateFormat("MM-dd");
    String sBirth = formatter.format(date);
    String sYear = getBuddhistCalendarYear(date);
    String result = sYear + "-" + sBirth;
    return result;
  }

  static DateTime getDateFromBuddhist(String strDate) {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    try {
      DateTime date = formatter.parse(strDate);
      return DateTime(date.year - 543, date.month, date.day);
    } catch (e) {
      print(e);
      return DateTime.now();
    }
  }

  static DateTime toBuddhist(DateTime date) {
    date = DateTime(date.year + 543, date.month, date.day, date.hour,
        date.minute, date.second);
    return date;
  }

  static DateTime fromBuddhist(DateTime date) {
    date = DateTime(date.year - 543, date.month, date.day, date.hour,
        date.minute, date.second);
    return date;
  }

  static String formatedStringFrom(DateTime date, {String locale = "th"}) {
    try {
      DateFormat format = DateFormat("dd MMM yyyy", locale);
      return format.format(toBuddhist(date));
    } catch (e) {
      print(e);
      return "";
    }
  }

  static String genderID(String th) {
    if (th == "หญิง") {
      return "woman";
    } else if (th == "ชาย") {
      return "man";
    } else if (th == "เพศทางเลือก") {
      return "alternative";
    } else {
      return "";
    }
  }

  static String genderTH(String id) {
    if (id == "woman") {
      return "หญิง";
    } else if (id == "man") {
      return "ชาย";
    } else if (id == "alternative") {
      return "เพศทางเลือก";
    } else {
      return "";
    }
  }

  static String gradeID(String th) {
    if (th.isEmpty) {
      return "";
    }

    try {
      FilterModel filterModel = FilterModel.getLevelMapping()
          .firstWhere((element) => element.nameTH == th);
      return filterModel.nameID;
    } catch (e) {
      return "";
    }
  }

  static String gradeTH(String id) {
    if (id.isEmpty) {
      return "";
    }

    try {
      FilterModel filterModel = FilterModel.getLevelMapping()
          .firstWhere((element) => element.nameID == id);
      return filterModel.nameTH;
    } catch (e) {
      return "";
    }
  }

  static String locationID(String th) {
    if (th.isEmpty) {
      return "";
    }

    try {
      FilterModel filterModel = FilterModel.getLocationMapping()
          .firstWhere((element) => element.nameTH == th);
      return filterModel.nameID;
    } catch (e) {
      return "";
    }
  }

  static String locationTH(String id) {
    if (id.isEmpty) {
      return "";
    }

    try {
      FilterModel filterModel = FilterModel.getLocationMapping()
          .firstWhere((element) => element.nameID == id);
      return filterModel.nameTH;
    } catch (e) {
      return "";
    }
  }

  static Future<dynamic> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      dynamic result = await getUserInfo(userCredential.user!.uid);

      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user";
      } else {
        return "Login Failed";
      }
    } catch (e) {
      return "Login Failed";
    }
  }

  static Future<String> signup(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print(userCredential.user!.uid);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup Failed";
    } catch (e) {
      return "Login Failed";
    }
  }

  static Future<String> saveUserInfo(
    String userID,
    String email,
    String name,
    String gender,
    String grade,
    String school,
    String tel,
    String lineID,
    String address,
    bool agreeToPrivacy,
    bool agreeToTerm,
    String nickname,
    String birthday,
    bool isTutorRequest,
  ) async {
    Map<String, dynamic> account = <String, dynamic>{"email": email};
    Map<String, dynamic> contact = <String, dynamic>{
      "email": email,
      "tel": tel,
      "line_id": lineID,
    };
    Map<String, dynamic> personal = <String, dynamic>{
      "name": name,
      "nickname": nickname,
      "gender": gender,
      "birthday": birthday,
      "grade": grade,
      "school": school,
      "address": address,
    };
    Map<String, dynamic> display = <String, dynamic>{
      "name": name,
      "grade": grade,
    };

    Map<String, dynamic> agree = <String, dynamic>{
      "agreeToPolicy_202105": agreeToPrivacy,
      "agreeToTerm_202105": agreeToTerm,
    };

    Map<String, dynamic> data;

    if (isTutorRequest) {
      data = <String, dynamic>{
        "isTutor": false,
        "isRequesting": true,
      };
    } else {
      data = <String, dynamic>{
        "isTutor": false,
      };
    }

    DocumentReference userRef =
        FirebaseFirestore.instance.collection("StudentIDs").doc(userID);
    CollectionReference infoRef = FirebaseFirestore.instance
        .collection("StudentIDs")
        .doc(userID)
        .collection("Information");

    CollectionReference tutorRef = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(userID)
        .collection("Information");

    var batch = FirebaseFirestore.instance.batch();
    batch.set(infoRef.doc("Account"), account);
    batch.set(infoRef.doc("Contact"), contact);
    batch.set(infoRef.doc("Personal"), personal);
    batch.set(infoRef.doc("Display"), display);
    batch.set(infoRef.doc("Agreement"), agree);
    batch.set(userRef, data, SetOptions(merge: true));

    if (isTutorRequest) {
      batch.set(tutorRef.doc("Account"), account);
      batch.set(tutorRef.doc("Contact"), contact);
      batch.set(tutorRef.doc("Personal"), personal);
      batch.set(tutorRef.doc("Display"), display);
    }

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
    return "Success";
  }

  static Future<dynamic> getUserInfo(String uid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(uid)
          .get(GetOptions(source: Source.server));
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      return "Convert Error";
    }
  }

  static Future<dynamic> getTutor(String uid,
      {String type = "Information"}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(uid)
          .collection(type)
          .get();

      if (snapshot.docs.length == 0) {
        return "Empty";
      } else {
        List<Map<String, dynamic>> data =
            snapshot.docs.map<Map<String, dynamic>>((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          return data;
        }).toList();

        Map<String, dynamic> allData = {};
        for (var item in data) {
          allData.addAll(item);
        }
        return allData;
      }
    } catch (e) {
      return "Convert Error";
    }
  }

  static Future<dynamic> getStudent(String uid) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(uid)
          .collection("Information")
          .get();

      if (snapshot.docs.length == 0) {
        return "Empty";
      } else {
        List<Map<String, dynamic>> data =
            snapshot.docs.map<Map<String, dynamic>>((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          return data;
        }).toList();

        Map<String, dynamic> allData = {};
        for (var item in data) {
          allData.addAll(item);
        }
        return allData;
      }
    } catch (e) {
      return "Convert Error";
    }
  }

  static Future<dynamic> saveDeviceToken(String uid) async {
    CollectionReference deviceRef =
        FirebaseFirestore.instance.collection("DeviceIDs");

    try {
      QuerySnapshot snapshot = await deviceRef
          .where("userID", isEqualTo: uid)
          .where("deviceID", isEqualTo: Globals.deviceToken)
          .get();
      if (snapshot.docs.isEmpty) {
        Map<String, dynamic> data = <String, dynamic>{
          "userID": uid,
          "deviceID": Globals.deviceToken,
        };

        DocumentReference doc = await deviceRef.add(data);
        log(doc.id);
        return "added";
      } else {
        return "existed";
      }
    } catch (e) {
      return "Convert Error";
    }
  }

  static Future<String> setNewTutor(
      String userID,
      String school,
      String degree,
      String study,
      String rate,
      String year,
      String bankNumber,
      String bankName,
      String idCard,
      String bankImageUrl,
      String cardImageUrl) async {
    Map<String, dynamic> personal = <String, dynamic>{
      "school": school,
      "degree": degree,
      "field_of_study": study,
      "rate": rate,
      "teaching_exp_year": year,
      "book_bank_name_filled": bankName,
      "book_bank_number_filled": bankNumber,
      "book_bank_img": bankImageUrl,
      "id_card_filled": idCard,
      "id_card_img": cardImageUrl,
    };

    Map<String, dynamic> display = <String, dynamic>{
      "school": school,
      "degree": degree,
      "field_of_study": study,
      "rate": rate,
      "teaching_exp_year": year
    };

    Map<String, dynamic> agree = <String, dynamic>{
      "term_agree_202105": true,
      "policy_agree_202105": true
    };

    CollectionReference tutorRef = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(userID)
        .collection("Information");

    var batch = FirebaseFirestore.instance.batch();

    batch.set(tutorRef.doc("Personal"), personal, SetOptions(merge: true));
    batch.set(tutorRef.doc("Display"), display, SetOptions(merge: true));
    batch.set(tutorRef.doc("Agreement"), agree, SetOptions(merge: true));

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
    return "Success";
  }

  static Future<String> uploadImage(File file, String type,
      {String? filename}) async {
    String extension = Path.extension(file.path);
    String refPath = "";

    switch (type) {
      case "id_card":
        refPath =
            "IdCardImage/" + Globals.currentUser!.uid + "/id_card" + extension;
        break;
      case "bank":
        refPath = "BookBankImage/" +
            Globals.currentUser!.uid +
            "/book_bank" +
            extension;
        break;
      case "tutor_invoice":
        refPath = "InvoiceImage/" +
            Globals.currentUser!.uid +
            "/" +
            filename! +
            extension;
        break;
      case "student_invoice":
        refPath = "StudentInvoiceImage/" +
            Globals.currentUser!.uid +
            "/" +
            filename! +
            extension;
        break;

      case "tutor_slip":
        refPath = "TutorSlipImage/" +
            Globals.currentUser!.uid +
            "/" +
            filename! +
            extension;
        break;

      default:
        refPath =
            "DisplayImage/" + Globals.currentUser!.uid + "/profile" + extension;
    }

    Reference ref = FirebaseStorage.instance.ref(refPath);
    UploadTask uploadTask = ref.putFile(file);
    // TaskSnapshot taskSnapshot = uploadTask.snapshot;
    // await uploadTask.whenComplete(() {
    //   taskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
    //     callback(downloadUrl);
    //   }, onError: (err) async {
    //     callback("ERROR_UPLOAD_IMAGE");
    //   });
    // });

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    try {
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return "ERROR_UPLOAD_IMAGE";
    }
  }

  static Future<void> updateContact(
      bool isTutor, String uid, Map<String, dynamic> data) async {
    DocumentReference ref;
    if (isTutor) {
      ref = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(uid)
          .collection("Information")
          .doc("Contact");
    } else {
      ref = FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(uid)
          .collection("Information")
          .doc("Contact");
    }

    await ref.set(data, SetOptions(merge: true));
  }

  static Future<void> updateInfo(bool isTutor, String uid,
      Map<String, dynamic> display, Map<String, dynamic> personal) async {
    CollectionReference ref;
    if (isTutor) {
      ref = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(uid)
          .collection("Information");
    } else {
      ref = FirebaseFirestore.instance
          .collection("StudentIDs")
          .doc(uid)
          .collection("Information");
    }

    var batch = FirebaseFirestore.instance.batch();

    batch.set(ref.doc("Personal"), personal, SetOptions(merge: true));
    batch.set(ref.doc("Display"), display, SetOptions(merge: true));

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  static Future<void> updateEducation(String uid, Map<String, dynamic> display,
      Map<String, dynamic> personal) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(uid)
        .collection("Information");

    var batch = FirebaseFirestore.instance.batch();

    batch.set(ref.doc("Personal"), personal, SetOptions(merge: true));
    batch.set(ref.doc("Display"), display, SetOptions(merge: true));

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  static Future<void> updatePromote(
      String uid, Map<String, dynamic> data) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(uid)
        .collection("Information")
        .doc("PromoteMessage");

    await ref.set(data, SetOptions(merge: true));
  }

  static Future<void> updateTeachLocation(
      String uid, Map<String, dynamic> data) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(uid)
        .collection("Teaching")
        .doc("locations");

    await ref.set(data);
  }

  static Future<void> updateTeachSubject(
      String uid, Map<String, dynamic> data) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(uid)
        .collection("Teaching")
        .doc("subjects");

    await ref.set(data);
  }

  static Future<void> updateTeachTesting(
      String uid, Map<String, dynamic> data) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("TutorIDs")
        .doc(uid)
        .collection("Teaching")
        .doc("testings");

    await ref.set(data);
  }

  static Future<void> addTutorToSubjectPool(
    String uid,
    Map<String, dynamic> subjectLevels,
    List<String> locations,
  ) async {
    Map<String, dynamic> data = {"lastUpdated": "2021-04-19"};

    var batch = FirebaseFirestore.instance.batch();

    subjectLevels.forEach((key, value) {
      CollectionReference colRef1 = FirebaseFirestore.instance
          .collection("Subjects")
          .doc(key)
          .collection("pool_level_0_location_0");
      CollectionReference colRef2 = FirebaseFirestore.instance
          .collection("Subjects")
          .doc(key)
          .collection("pool_level_x_location_0");

      // all_levels - pool_level_0_location_0
      batch.set(colRef1.doc("all_levels").collection("all_locations").doc(uid),
          data, SetOptions(merge: true));

      for (var location in locations) {
        batch.set(colRef1.doc("all_levels").collection(location).doc(uid), data,
            SetOptions(merge: true));
      }

      // all_levels - pool_level_x_location_0
      batch.set(colRef2.doc("all_levels").collection("all_locations").doc(uid),
          data, SetOptions(merge: true));

      for (var location in locations) {
        batch.set(colRef2.doc("all_levels").collection(location).doc(uid), data,
            SetOptions(merge: true));
      }

      // each levels
      for (var level in (value as List<dynamic>)) {
        batch.set(colRef1.doc(level).collection("all_locations").doc(uid), data,
            SetOptions(merge: true));

        for (var location in locations) {
          batch.set(colRef1.doc(level).collection(location).doc(uid), data,
              SetOptions(merge: true));
        }
      }
    });

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  static Future<void> deleteTutorFromSubjectPool(
    String uid,
    Map<String, dynamic> subjectLevels,
    List<String> locations,
  ) async {
    var batch = FirebaseFirestore.instance.batch();

    subjectLevels.forEach((key, value) {
      CollectionReference colRef1 = FirebaseFirestore.instance
          .collection("Subjects")
          .doc(key)
          .collection("pool_level_0_location_0");
      CollectionReference colRef2 = FirebaseFirestore.instance
          .collection("Subjects")
          .doc(key)
          .collection("pool_level_x_location_0");

      // all_levels - pool_level_0_location_0
      batch.delete(
          colRef1.doc("all_levels").collection("all_locations").doc(uid));

      for (var location in locations) {
        batch.delete(colRef1.doc("all_levels").collection(location).doc(uid));
      }

      // all_levels - pool_level_x_location_0
      batch.delete(
          colRef2.doc("all_levels").collection("all_locations").doc(uid));

      for (var location in locations) {
        batch.delete(colRef2.doc("all_levels").collection(location).doc(uid));
      }

      // each levels
      for (var level in (value as List<dynamic>)) {
        batch.delete(colRef1.doc(level).collection("all_locations").doc(uid));

        for (var location in locations) {
          batch.delete(colRef1.doc(level).collection(location).doc(uid));
        }
      }
    });

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  static Future<void> addTutorToTestingPool(
    String uid,
    List<dynamic> testings,
    List<String> locations,
  ) async {
    Map<String, dynamic> data = {"lastUpdated": "2021-04-19"};

    var batch = FirebaseFirestore.instance.batch();
    for (var test in testings) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Testings").doc(test);

      batch.set(docRef.collection("all_locations").doc(uid), data,
          SetOptions(merge: true));

      for (var location in locations) {
        batch.set(docRef.collection(location).doc(uid), data,
            SetOptions(merge: true));
      }
    }

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  static Future<void> deleteTutorFromTestingPool(
    String uid,
    List<dynamic> testings,
    List<String> locations,
  ) async {
    var batch = FirebaseFirestore.instance.batch();
    for (var test in testings) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Testings").doc(test);

      batch.delete(docRef.collection("all_locations").doc(uid));

      for (var location in locations) {
        batch.delete(docRef.collection(location).doc(uid));
      }
    }

    await batch.commit().then((value) {}, onError: (e) {
      print(e);
    });
  }

  static Future<String> reportUser(
      String receiverID, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("ReportUser")
          .doc("Chat")
          .collection(receiverID)
          .add(data);

      return "Success";
    } catch (e) {
      return "Convert Error";
    }
  }

  static Future<dynamic> getTutorProfile(String uid) async {
    dynamic information = await Util.getTutor(uid, type: "Information");
    dynamic teaching = await Util.getTutor(uid, type: "Teaching");

    if (information is String) {
      return information;
    }

    Map<String, dynamic> data = information as Map<String, dynamic>;

    if (teaching is Map) {
      List<String> subjectTHs = [];
      if (teaching["subject_levels"] != null) {
        Map<String, dynamic> levelMap =
            teaching["subject_levels"] as Map<String, dynamic>;
        subjectTHs = levelMap.keys.map<String>((e) {
          TopicModel topicModel = TopicModel.getSubjects()
              .firstWhere((element) => element.titleID == e);
          return topicModel.titleTH;
        }).toList();
      }

      return TutorCardModel(
        tutorID: uid,
        nickname: data["nickname"] ?? "",
        name: data["name"] ?? "",
        profileUrl: data["display_img"] ?? "",
        degree: data["degree"] ?? "",
        study: data["field_of_study"] ?? "",
        school: data["school"] ?? "",
        teachYear: data["teaching_exp_year"] ?? "",
        rate: data["rate"] ?? "",
        followee: (data["followee"] == null)
            ? []
            : (data["followee"] as List)
                .map<String>((e) => e.toString())
                .toList(),
        locations: (teaching["locations"] == null)
            ? []
            : (teaching["locations"] as List)
                .map<String>((e) => e.toString())
                .toList(),
        subjectLevels: (teaching["subject_levels"] == null)
            ? {}
            : (teaching["subject_levels"] as Map<String, dynamic>),
        subjectTHs: subjectTHs,
        testings: (teaching["testings"] == null)
            ? []
            : (teaching["testings"] as List)
                .map<String>((e) => e.toString())
                .toList(),
        promo: data["promote_message"] ?? "",
      );
    } else {
      return TutorCardModel(
        tutorID: uid,
        nickname: data["nickname"] ?? "",
        name: data["name"] ?? "",
        profileUrl: data["display_img"] ?? "",
        degree: data["degree"] ?? "",
        study: data["field_of_study"] ?? "",
        school: data["school"] ?? "",
        teachYear: data["teaching_exp_year"] ?? "",
        rate: data["rate"] ?? "",
        followee: (data["followee"] == null)
            ? []
            : (data["followee"] as List)
                .map<String>((e) => e.toString())
                .toList(),
        locations: [],
        subjectLevels: {},
        subjectTHs: [],
        testings: [],
        promo: data["promote_message"] ?? "",
      );
    }
  }

  static Future<List<int>> getUnavailabeSlot(
      String uid, DateTime dateTime) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(uid)
          .collection("Timetable")
          .doc(DateFormat("yyyy-MM-dd").format(dateTime))
          .get();

      if (snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<int> slots =
            (data["timeIndex"] as List).map<int>((e) => e.toInt()).toList();
        return slots;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String> updateClass(
      String id, Map<String, dynamic> newData) async {
    try {
      DocumentReference reference =
          FirebaseFirestore.instance.collection("ClassIDs").doc(id);

      await reference.set(newData, SetOptions(merge: true));

      return "Success";
    } catch (e) {
      return "Failed";
    }
  }

  static Future<String> updateTimeSlot(
      String uid, DateTime dateTime, List<int> slots) async {
    try {
      Map<String, dynamic> data = {"timeIndex": slots};
      DocumentReference reference = FirebaseFirestore.instance
          .collection("TutorIDs")
          .doc(uid)
          .collection("Timetable")
          .doc(DateFormat("yyyy-MM-dd").format(dateTime));

      await reference.set(data);

      return "Success";
    } catch (e) {
      return "Failed";
    }
  }
}
