import 'package:flutter/material.dart';
import 'package:neighbours/res/res_index.dart';

class RippleLayout extends StatelessWidget {
  //半径
  final double radius;
  //水波纹宽度
  final double width;
  //水波纹高度
  final double height;
  //按钮区域颜色
  final Color btnColor;
  //点击回调
  final GestureTapCallback tapCallback;
  //水波纹颜色
  final Color rippleColor;
  //点击|触摸时候显示的颜色
  final Color touchColor;

  final bool isCircle;
  final bool isContained;
  //子view
  final Widget child;

  const RippleLayout({
    Key key,
    this.radius: 0.0,
    this.width: double.infinity,
    this.height: double.infinity,
    this.btnColor: Colors.transparent,
    this.tapCallback,
    //rippleColor如果没有手动设置颜色,那么我们则使用Theme.of(context).splashColor
    this.rippleColor,
    this.isCircle,
    this.isContained: true,
    //touchColor如果没有手动设置颜色,那么我们则使用Theme.of(context).highlightColor
    this.touchColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Ink(
        decoration: new BoxDecoration(
          color: this.btnColor,
          borderRadius: new BorderRadius.all(new Radius.circular(this.radius)),
        ),
        child: new InkResponse(
          borderRadius: new BorderRadius.all(new Radius.circular(this.radius)),
          // highlightColor: Colors.yellowAccent,//点击或者toch控件高亮时显示的控件在控件上层,水波纹下层
          //点击|触摸的时候,高亮显示的颜色
          // highlightColor: this.touchColor != Colors.white
          //     ? this.touchColor
          //     : Theme.of(context).highlightColor,
           highlightShape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          //波纹扩散颜色
          splashColor: this.rippleColor != Colors.white
              ? this.rippleColor
              : Theme.of(context).splashColor,
          //.InkResponse内部的radius这个需要注意的是，我们需要半径大于控件的宽，如果radius过小，显示的水波纹就是一个很小的圆，
          radius: 300.0, //水波纹的半径
          containedInkWell:
              isContained, //true表示要剪裁水波纹响应的界面   false不剪裁  如果控件是圆角不剪裁的话水波纹是矩形
          onTap: this.tapCallback,
          child: new Container(
            width: this.width,
            height: this.height,
            alignment: Alignment.center,
            child: this.child,
          ),
        ),
      ),
    );
  }
}
