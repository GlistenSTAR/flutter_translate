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
          notification.imageUrl.isEmpty
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
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                Text(
                  notification.message,
                  style: TextStyle(color: COLOR.DARK_GREY),
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
