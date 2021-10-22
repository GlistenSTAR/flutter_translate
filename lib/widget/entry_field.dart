import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';

class EntryField extends StatelessWidget {
  EntryField({
    Key? key,
    required this.controller,
    required this.icon,
    this.hint,
    this.isPassword,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          padding: EdgeInsets.only(left: 76, right: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.8),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.black, fontSize: 20),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: COLOR.DARK_GREY),
              hintText: hint ?? "",
            ),
            obscureText: isPassword ?? false,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Icon(
            icon,
            color: COLOR.DARK_GREY,
          ),
        ),
      ],
    );
  }
}
