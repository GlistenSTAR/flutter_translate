import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/FilterModel.dart';
import 'package:tutor/model/TopicModel.dart';
import 'package:tutor/model/TutorCardModel.dart';
import 'package:tutor/utils/const.dart';
import 'package:tutor/widget/tag_item.dart';

class LikeCard extends StatelessWidget {
  const LikeCard({Key? key, required this.model, required this.callback})
      : super(key: key);

  final TutorCardModel model;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 2),
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 2)
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
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        model.nickname,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          fontFamily: 'Prompt',
                                          letterSpacing: 0.12,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                model.rate,
                                style: TextStyle(
                                  color: COLOR.YELLOW,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Prompt',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  model.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF999999),
                                    fontFamily: 'Prompt',
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                "บาท/ชั่วโมง",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF999999),
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
                _detailRow("วิชาที่สอน", ""),
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
                _detailRow("ติวสอบ", ""),
                Container(
                  height: 36,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String titleID = model.testings[index];
                        TopicModel topicModel = TopicModel.getTests()
                            .firstWhere(
                                (element) => element.titleID == titleID);

                        return TagItem(title: topicModel.titleTH);
                      },
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemCount: model.testings.length),
                ),
                SizedBox(height: 8),
                _detailRow("สถานที่สอน", ""),
                Container(
                  height: 36,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String nameID = model.locations[index];
                        FilterModel filterModel =
                            FilterModel.getLocationMapping().firstWhere(
                                (element) => element.nameID == nameID);

                        return TagItem(title: filterModel.nameTH);
                      },
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemCount: model.locations.length),
                ),
                SizedBox(height: 8),
                _detailRow("ประสบการณ์การสอน", "${model.teachYear} ปี"),
              ],
            ),
          ),
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
            fontFamily: 'Prompt',
            letterSpacing: 0.12,
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
