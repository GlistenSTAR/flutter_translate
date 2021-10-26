import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/RecentChatModel.dart';
import 'package:tutor/utils/const.dart';

class ConversationCell extends StatelessWidget {
  ConversationCell({Key? key, required this.model, this.callback})
      : super(key: key);

  final RecentChatModel model;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Row(
        children: [
          model.displayImg.isEmpty
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
                    imageUrl: model.displayImg,
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      model.date,
                      style: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        model.lastMsg,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: COLOR.DARK_GREY, fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      model.time,
                      style: TextStyle(color: COLOR.DARK_GREY),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
