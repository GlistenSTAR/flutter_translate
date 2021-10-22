import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tutor/utils/const.dart';

class FullScreen extends StatelessWidget {
  FullScreen({Key? key, required this.provider, required this.url})
      : super(key: key);

  final ImageProvider provider;
  final String url;
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 50);
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: COLOR.YELLOW,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: provider, fit: BoxFit.contain),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => FutureProgressDialog(
                    saveImageToGallery(),
                    message: Text("Please wait for a moment..."),
                  ),
                );
              },
              child: Text(
                "บันทึกรูป",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> saveImageToGallery() async {
    await GallerySaver.saveImage(url + ".jpg").then((bool? success) {
      if (success == true) {
        showToast("Image saved");
      }
    });
  }
}
