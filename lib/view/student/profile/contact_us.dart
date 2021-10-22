import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/utils/const.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  ContactUs({Key? key, required this.email}) : super(key: key);

  final String email;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "ติดต่อเรา",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: email,
                        query: encodeQueryParameters(
                            <String, String>{'subject': 'Contact Us'}),
                      );

                      launch(emailLaunchUri.toString());
                    },
                    child: Text(
                      "Email: $email",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Divider(height: 24),
                  InkWell(
                    onTap: () => launch("https://www.facebook.com/TUTORHAUS/"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Facebook: TUTOR HAUS",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: COLOR.YELLOW,
                          radius: 8,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(height: 24),
                  InkWell(
                    onTap: () => launch("https://page.line.me/tutorhaus"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Line: @tutorhaus",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: COLOR.YELLOW,
                          radius: 8,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
