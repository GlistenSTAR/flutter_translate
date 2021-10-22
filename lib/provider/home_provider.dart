import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeProvider with ChangeNotifier {
  bool? _subjectSearch;

  bool get isSubjectMode {
    return _subjectSearch ?? true;
  }

  set isSubjectMode(bool value) {
    _subjectSearch = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> loadLocalTerms() async {
    try {
      String response = await rootBundle.loadString('assets/terms.json');
      Map<String, dynamic> result = json.decode(response);
      return result;
    } catch (e) {
      throw Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Convert Error'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> loadLocalPolicy() async {
    try {
      String response = await rootBundle.loadString('assets/policy.json');
      Map<String, dynamic> result = json.decode(response);
      return result;
    } catch (e) {
      throw Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Convert Error'),
        ),
      );
    }
  }
}
