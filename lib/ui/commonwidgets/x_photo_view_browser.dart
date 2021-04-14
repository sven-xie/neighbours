import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

/// 图片查看
class XPhotoViewBrowser extends StatelessWidget {
  final Widget child;
  final List<String> pics;

  int currentIndex = 0;

  XPhotoViewBrowser(
      {Key key, this.child, @required this.pics, this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: ExtendedImageGesturePageView.builder(
          itemBuilder: (BuildContext context, int index) {
            var url = pics[index];
            Widget image = ExtendedImage.network(
              url,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 3.0,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: false);
              },
            );
            image = Container(
              child: image,
              padding: EdgeInsets.all(5.0),
            );
            if (index == currentIndex) {
              return Hero(
                tag: url + index.toString(),
                child: image,
              );
            } else {
              return image;
            }
          },
          itemCount: pics.length,
          onPageChanged: (int index) {
            currentIndex = index;
          },
          controller: PageController(
            initialPage: currentIndex,
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
