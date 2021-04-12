import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/utils/utils.dart';

typedef OnTab = void Function();

class CacheImgRadius extends StatelessWidget {
  final String imgUrl;
  final double radius;
  final OnTab onTab;
  CacheImgRadius({Key key, @required this.imgUrl, this.radius, this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: ExtendedImage.network(
          imgUrl,
          fit: BoxFit.cover,
          cache: true,
        ),
      ),
      onTap: () {
        onTab();
      },
    );
  }
}

class CacheImgCircle extends StatelessWidget {
  final String imgUrl;
  final double radius;
  final OnTab onTab;
  CacheImgCircle({Key key, @required this.imgUrl, this.radius, this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ExtendedImage.network(
          imgUrl,
          fit: BoxFit.cover,
          cache: true,
          width: radius*2,
          height: radius*2,
          shape: BoxShape.circle,
      ),
      onTap: () {
        onTab();
      },
    );
  }
}

class Img extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double radius;
  final bool isCircle;
  final Color color;
  final BoxFit fit;
  final bool noSetReqImgSize;

  Img(this.url,
      {this.radius: 4,
      this.isCircle: false,
      this.width,
      this.height,
      this.noSetReqImgSize: false,
      this.color: Colors.transparent,
      this.fit: BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: url == null ? _placeholderPic() : _fadeInImage()),
    );
  }

  _fadeInImage() {
    return FadeInImage(
      width: this.isCircle ? radius * 2 : width,
      height: this.isCircle ? radius * 2 : height,
      placeholder: AssetImage(Utils.getImgPath("placeholder_pic")),
      image:
          ExtendedNetworkImageProvider(noSetReqImgSize ? _setReqImgSize() : url),
      fit: BoxFit.fill,
    );
  }

  _placeholderPic() {
    return Image.asset(
      Utils.getImgPath("placeholder_pic"),
      width: this.isCircle ? radius * 2 : width,
      height: this.isCircle ? radius * 2 : height,
      fit: fit,
    );
  }

  _setReqImgSize() {
    int imgWidth = ((this.isCircle ? radius * 2 : width) * 1.6).round();
    int imgHeight = ((this.isCircle ? radius * 2 : height) * 1.6).round();

    return "$url?imageView=1&thumbnail=${imgWidth}z$imgHeight&type=webp&quality=90";
  }

  getReqImgSize() => _setReqImgSize();
}
