import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/widget/entry_field.dart';

class ResetPage extends StatelessWidget {
  ResetPage({Key? key}) : super(key: key);

  final TextEditingController teEmail = TextEditingController();
  final TextEditingController tePassword = TextEditingController();
  final TextEditingController teConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR.BLUE,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("images/common/logo.png"),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "ตั้งรหัสผ่านใหม่",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  EntryField(
                    controller: teEmail,
                    icon: Icons.person_outline,
                    hint: "อีเมล",
                  ),
                  SizedBox(height: 16),
                  EntryField(
                    controller: tePassword,
                    icon: Icons.lock_outline,
                    hint: "รหัสผ่านใหม่ (อย่างน้อย 6 ตัว)",
                    isPassword: true,
                  ),
                  SizedBox(height: 16),
                  EntryField(
                    controller: teConfirm,
                    icon: Icons.lock_outline,
                    hint: "ยืนยันรหัสผ่านใหม่",
                    isPassword: true,
                  ),
                  SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () async {
                      //reset password
                      FocusScope.of(context).unfocus();

                      String email = teEmail.text.trim();
                      String password = tePassword.text;
                      String cpassword = teConfirm.text;

                      if (email.isEmpty || password.isEmpty) {
                        showToast("กรุณากรอกอีเมลและรหัสผ่าน");
                        return;
                      }

                      if (password != cpassword) {
                        showToast("รหัสผ่านไม่ตรงกัน");
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);

                        showAlertDialog(context, "ตั้งรหัสผ่านใหม่",
                            "Password Reset Link Has Been Sent");
                      } catch (e) {}
                    },
                    child: Text(
                      "ยืนยัน",
                      style: TextStyle(
                        color: COLOR.YELLOW,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 48),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
