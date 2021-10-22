import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';

class PromotePage extends StatefulWidget {
  PromotePage({Key? key, required this.info}) : super(key: key);

  final Map<String, dynamic> info;

  @override
  _PromotePageState createState() => _PromotePageState();
}

class _PromotePageState extends State<PromotePage> {
  final tePromote = TextEditingController();

  @override
  void initState() {
    super.initState();
    tePromote.text = widget.info["promote_message"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: COLOR.YELLOW,
          ),
        ),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "แก้ไขประวัติการสอนเพิ่มเติม",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: tePromote,
                    maxLines: 20,
                    maxLength: 256,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "เพิ่มคำโปรโมทตรงนี้",
                      hintStyle: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateInfo();
                },
                child: Text(
                  "บันทึก",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  primary: COLOR.YELLOW,
                  onPrimary: Colors.white,
                  minimumSize: Size(MediaQuery.of(context).size.width, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateInfo() async {
    FocusScope.of(context).unfocus();
    String promote = tePromote.text.trim();

    Map<String, dynamic> data = {
      "promote_message": promote,
    };

    await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(
        Util.updatePromote(Globals.currentUser!.uid, data),
        message: Text('Please wait for a moment...'),
      ),
    );

    Navigator.of(context).pop(data);
  }
}
