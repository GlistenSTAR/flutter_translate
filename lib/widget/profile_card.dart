import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/utils/util.dart';
import 'package:tutor/widget/tag_item.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tutor/widget/rating_percent.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {Key? key,
      required this.model,
      this.onFavorite,
      this.onView,
      this.onReserve})
      : super(key: key);

  final TutorCardModel model;
  final VoidCallback? onFavorite, onView, onReserve;

  @override
  Widget build(BuildContext context) {
    double rating = 0;
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("ClassIDs")
            .where("tutor_id", isEqualTo: model.tutorID)
            .where("tutor_review", isNotEqualTo: null)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> classes =
                snapshot.data!.docs.map<Map<String, dynamic>>((e) {
              return e.data() as Map<String, dynamic>;
            }).toList();

            int rate1 = 0;
            int rate2 = 0;
            int rate3 = 0;
            int rate4 = 0;
            int rate5 = 0;

            for (var classData in classes) {
              int rating = classData["tutor_rating"] == null
                  ? 0
                  : classData["tutor_rating"].toInt();
              switch (rating) {
                case 1:
                  rate1++;
                  break;
                case 2:
                  rate2++;
                  break;
                case 3:
                  rate3++;
                  break;
                case 4:
                  rate4++;
                  break;
                case 5:
                  rate5++;
                  break;

                default:
              }
            }

            int sum = rate1 + 2 * rate2 + 3 * rate3 + 4 * rate4 + 5 * rate5;
            int count = rate1 + rate2 + rate3 + rate4 + rate5;
            rating = count == 0 ? 0 : (sum / count);
          }

          return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 3)
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.white,
                          spreadRadius: 1,
                          blurRadius: 1)
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          model.profileUrl.isEmpty
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
                                    imageUrl: model.profileUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        ClipOval(
                                      child: Image.asset(
                                        "images/common/logo.png",
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2)),
                                          Flexible(
                                            child: Text(
                                              model.nickname,
                                              style: TextStyle(
                                                fontFamily: 'Prompt',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: onFavorite,
                                            child: Icon(
                                              model.followee.contains(
                                                      Globals.currentUser!.uid)
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      model.rate,
                                      style: TextStyle(
                                        color: COLOR.YELLOW,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2)),
                                          Flexible(
                                            child: Text(
                                              model.name,
                                              style: TextStyle(
                                                  color: COLOR.DARK_GREY),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      "บาท/ชั่วโมง",
                                      style: TextStyle(
                                        color: COLOR.DARK_GREY,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Spacer(),
                                        // Text(
                                        //   rating.toStringAsFixed(2) + "/ 5",
                                        //   style: TextStyle(
                                        //     fontSize: 16,
                                        //     fontWeight: FontWeight.w800,
                                        //   ),
                                        // ),
                                        RatingBar.builder(
                                          itemCount: 5,
                                          itemSize: 20,
                                          initialRating: rating,
                                          itemPadding: EdgeInsets.only(
                                              left: 0, right: 4),
                                          ignoreGestures: true,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: COLOR.YELLOW,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      _detailRow("คณะ", model.study),
                      _detailRow("ระดับ", model.degree),
                      _detailRow("สถาบัน", model.school),
                      SizedBox(height: 8),
                      _detailRow("ประสบการณ์การสอน", "${model.teachYear} ปี"),
                      SizedBox(height: 8),
                      _detailRow("ระดับชั้น", ""),
                      Container(
                        height: 36,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return TagItem(title: model.subjectTHs[index]);
                            },
                            separatorBuilder: (_, __) => SizedBox(width: 16),
                            itemCount: model.subjectTHs.length),
                      ),
                      SizedBox(height: 8),
                      _detailRow("สถานที่สอน", ""),
                      Container(
                        height: 36,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return TagItem(
                                  title:
                                      Util.locationTH(model.locations[index]));
                            },
                            separatorBuilder: (_, __) => SizedBox(width: 16),
                            itemCount: model.locations.length),
                      ),
                      SizedBox(height: 8),
                      _detailRow("ประวัติการสอนเพิ่มเติม", ""),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.promo.length > 200
                              ? model.promo.substring(1, 200) + "..."
                              : model.promo,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: onView,
                          child: Text(
                            "อ่านประวัติเพิ่มเติม",
                            style: TextStyle(color: COLOR.YELLOW),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: onReserve,
                          child: Text(
                            "ดูตารางและจอง",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 48),
                            primary: COLOR.BLUE,
                            onPrimary: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _detailRow(String title, String description) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Prompt',
            color: COLOR.BLUE,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            description,
            style: TextStyle(
              fontFamily: 'Prompt',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  double getPercent(int sub, int total) {
    return total == 0 ? 0 : (sub / total);
  }
}
