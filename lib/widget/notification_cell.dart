import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/model/NotificationModel.dart';
import 'package:tutor/utils/const.dart';

class NotificationCell extends StatelessWidget {
  NotificationCell({Key? key, required this.notification, this.callback})
      : super(key: key);

  final NotificationModel notification;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
              color: notification.isReaded
                  ? Colors.white
                  : Color.fromRGBO(232, 242, 250, 1),
            ),
            child: notification.imageUrl.isEmpty
                ? Image.asset(
                    "images/common/logo.png",
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  )
                : Container(
                    width: 50,
                    height: 50,
                    child: CachedNetworkImage(
                      imageUrl: notification.imageUrl,
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
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.12,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: COLOR.DARK_GREY,
                    fontSize: 14,
                    fontFamily: 'Prompt',
                    letterSpacing: 0.12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            notification.displayTime(),
            style: TextStyle(color: COLOR.DARK_GREY),
          ),
        ],
      ),
    );
  }
}
