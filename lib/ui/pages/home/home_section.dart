import 'package:flutter/material.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:neighbours/res/res_index.dart';

class HomeSectionView extends StatelessWidget {
  final String title;
  final Function onTap;
  HomeSectionView(this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return CContainer(
      height: 40.0,
      color: Colours.white,
      padding: EdgeInsetsDirectional.only(start: 10.0,end: 10.0),
      direction: Direction.row,
      children: <Widget>[
        CText(
          title,
          textSize: 14,
          imageAsset: Utils.getImgPath("home_tip"),
          imageScale: 1.2,
          drawableDirection: DrawableDirection.left,
          drawablePadding: 10,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onTap,
              child: CText(
                "更多",
                textSize: 14,
                icon: Icons.keyboard_arrow_right,
                iconSize: 20.0,
                imageScale: 1.2,
                drawableDirection: DrawableDirection.right,
                drawablePadding: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
