import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/util.dart';

class ReviewCell extends StatelessWidget {
  const ReviewCell({Key? key, required this.classData}) : super(key: key);

  final Map<String, dynamic> classData;

  @override
  Widget build(BuildContext context) {
    double rating = classData["tutor_rating"] ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: Util.getStudent(classData["student_id"]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data is String) {
                  return Container();
                }

                Map<String, dynamic> student =
                    snapshot.data as Map<String, dynamic>;

                return Row(
                  children: [
                    student["display_img"] == null
                        ? Image.asset(
                            "images/common/logo.png",
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            child: CachedNetworkImage(
                              imageUrl: student["display_img"],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => ClipOval(
                                child: Image.asset(
                                  "images/common/logo.png",
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  student["nickname"] ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                "ในวันที่ " +
                                    getBuddhistFrom(classData["class_date"]),
                                style: TextStyle(
                                  color: COLOR.TEXT_DARK,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              RatingBar.builder(
                                itemCount: 5,
                                itemSize: 16,
                                initialRating: rating,
                                itemPadding: EdgeInsets.zero,
                                ignoreGestures: true,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: COLOR.YELLOW,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              SizedBox(width: 8),
                              Text(
                                "${rating.toInt()} ดาว จาก 5 ดาว",
                                style: TextStyle(
                                  color: COLOR.TEXT_LIGHT,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Padding(
          padding: EdgeInsets.only(left: 76),
          child: Text(classData["tutor_review"] ?? ""),
        ),
      ],
    );
  }

  String getBuddhistFrom(String strDate) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd");
      DateTime date = format.parse(strDate);
      format = DateFormat("dd/MM/yy");
      return format.format(Util.toBuddhist(date));
    } catch (e) {
      print(e);
      return "";
    }
  }
}
