import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/ui/widgets/c_container.dart';

class CImage extends StatelessWidget{

  String url;
  String asset;
  double heiget;
  double width;
  BoxFit fit;
  double scale;

  double borderRadius;
  double leftTopRadius;
  double leftBottomRadius;
  double rightTopRadius;
  double rightBottomRadius;
  double borderWidth;
  Color borderColor;

  /**
   * scale属性只对asset有用
   * */
  CImage({this.url, this.asset, this.heiget, this.width,this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.leftTopRadius,
    this.leftBottomRadius,
    this.rightTopRadius,
    this.rightBottomRadius,
    this.borderWidth = 0,
    this.borderColor,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    borderColor = borderWidth > 0 && borderColor == null ? Colors.grey[300]:Colors.transparent;

    return CContainer(width: width,height: heiget,child: borderWidget(),borderWidth: borderWidth,borderColor: borderColor,
        borderRadius: borderRadius,leftBottomBorderRadius: leftBottomRadius,leftTopBorderRadius: leftTopRadius,rightBottomBorderRadius: rightBottomRadius,rightTopBorderRadius: rightTopRadius,);
  }

  Widget borderWidget(){
    leftTopRadius = leftTopRadius ?? borderRadius;
    leftBottomRadius = leftBottomRadius ?? borderRadius;
    rightTopRadius = rightTopRadius ?? borderRadius;
    rightBottomRadius = rightBottomRadius ?? borderRadius;
    return ClipRRect(
      child: getChild(),
      borderRadius:BorderRadius.only(
        topLeft: Radius.circular(leftTopRadius),
        topRight: Radius.circular(rightTopRadius),
        bottomLeft: Radius.circular(leftBottomRadius),
        bottomRight: Radius.circular(rightBottomRadius)
      )
    );
  }

  Widget getChild(){
    if(url != null) return ExtendedImage.network(url,fit: fit,);
    if(asset != null) return Image.asset(asset,fit: fit,scale: scale,);
  }

}