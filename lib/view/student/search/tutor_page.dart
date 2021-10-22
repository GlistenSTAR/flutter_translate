import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/view/student/search/tutor_time.dart';
import 'package:tutor/view/tutor/schedule/schedule_view.dart';
import 'package:tutor/widget/rating_percent.dart';
import 'package:tutor/widget/review_cell.dart';
import 'package:tutor/widget/tag_item.dart';

class TutorPage extends StatelessWidget {
  const TutorPage({Key? key, required this.model}) : super(key: key);

  final TutorCardModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
                          imageBuilder: (context, imageProvider) => Container(
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
                              model.nickname,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              model.name,
                              style: TextStyle(color: COLOR.DARK_GREY),
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
                    return TagItem(title: model.locations[index]);
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 16),
                  itemCount: model.locations.length),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                model.promo,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ประวัติการสอนเพิ่มเติม",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: COLOR.BLUE,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Additional teaching history",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            _detailRow("รีวิวและคะแนนการสอน", ""),
            SizedBox(height: 8),
            _reviewWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => onReserve(context),
                child: Text(
                  "ดูตารางและจอง",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width, 48),
                  primary: COLOR.BLUE,
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onReserve(BuildContext context) {
    //Need to open the tutor's time table
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => TutorTime(model: model),
      ),
    );
  }

  Widget _detailRow(String title, String description) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: COLOR.BLUE,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            description,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _reviewWidget() {
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
            double rating = count == 0 ? 0 : (sum / count);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "  จาก 5",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    RatingBar.builder(
                      itemCount: 5,
                      itemSize: 26,
                      initialRating: rating,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      ignoreGestures: true,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: COLOR.YELLOW,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "ทั้งหมด $count คน",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(height: 8),
                RatingPercent(rating: 5, percent: getPercent(rate5, count)),
                SizedBox(height: 8),
                RatingPercent(rating: 4, percent: getPercent(rate4, count)),
                SizedBox(height: 8),
                RatingPercent(rating: 3, percent: getPercent(rate3, count)),
                SizedBox(height: 8),
                RatingPercent(rating: 2, percent: getPercent(rate2, count)),
                SizedBox(height: 8),
                RatingPercent(rating: 1, percent: getPercent(rate1, count)),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ทั้งหมด $count รีวิว",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                ),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> classData = classes[index];
                      return ReviewCell(classData: classData);
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: classes.length),
              ],
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  double getPercent(int sub, int total) {
    return total == 0 ? 0 : (sub / total);
  }
}
