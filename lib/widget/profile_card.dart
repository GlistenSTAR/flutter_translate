import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/utils/globals.dart';
import 'package:tutor/widget/tag_item.dart';

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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
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
                                InkWell(
                                  onTap: onFavorite,
                                  child: Icon(
                                    model.followee
                                            .contains(Globals.currentUser!.uid)
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
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
                                Flexible(
                                  child: Text(
                                    model.name,
                                    style: TextStyle(color: COLOR.DARK_GREY),
                                  ),
                                ),
                                InkWell(
                                  onTap: onView,
                                  child: Icon(
                                    Icons.star,
                                    color: COLOR.YELLOW,
                                  ),
                                ),
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
                  minimumSize: Size(MediaQuery.of(context).size.width, 48),
                  primary: COLOR.BLUE,
                  onPrimary: Colors.white,
                ),
              ),
            )
          ],
        ),
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
            fontWeight: FontWeight.bold,
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
}
