import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin COLOR {
  static const Color BLUE = Color(0xFF0072C2);
  static const Color DARK = Color(0xFF7E807E);
  static const Color LIGHT_GREY = Color(0xFFF1F1F1);
  static const Color DARK_GREY = Color(0xFF7F7F7F);
  static const Color YELLOW = Color(0xFFFFAA1C);
  static const Color TEXT_DARK = Color(0xFF8F8C8C);
  static const Color TEXT_LIGHT = Color(0xFFB7B5B5);
  static const Color TEXT_HINT = Color(0xFFB2B0B0);
  static const Color TEXT_BORDER = Color(0xFFC4C4C4);
  static const Color BACK_GREY = Color(0xFFE6E6E6);
}

showAlertDialog(BuildContext context, String title, String description) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}