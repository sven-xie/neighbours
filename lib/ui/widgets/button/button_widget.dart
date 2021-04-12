import 'package:flutter/material.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/utils/util_index.dart';

class PlatformTapWidget extends StatefulWidget {
  final double radius;
  final Function onTap;
  final Widget child;
  final double elevation;
  final Color backgroundColor;
  final Color splashColor;
  final Function onLongTap;
  final Function onDoubleTap;

  const PlatformTapWidget({
    Key key,
    this.radius = 0.0,
    this.onTap,
    this.elevation,
    this.backgroundColor = Colors.white,
    this.splashColor,
    this.onLongTap,
    this.child,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  _PlatformTapWidgetState createState() => _PlatformTapWidgetState();
}

class _PlatformTapWidgetState extends State<PlatformTapWidget> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    Color splashColor = widget.splashColor ?? Colors.grey.withOpacity(0.3);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      Widget w;

      w = ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.onTap,
          onTapDown: (d) => setState(() => this.isDown = true),
          onTapUp: (d) => setState(() => this.isDown = false),
          onTapCancel: () => setState(() => this.isDown = false),
          onDoubleTap: widget.onDoubleTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 600),
            curve: Curves.easeIn,
            color: isDown ? splashColor : widget.backgroundColor,
            child: widget.child,
          ),
        ),
      );

      return w;
    }

    Widget w = ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Material(
        borderRadius: BorderRadius.circular(widget.radius),
        color: widget.backgroundColor,
        elevation: 0.0,
        child: InkWell(
          child: widget.child,
          onTap: widget.onTap,
          onLongPress: widget.onLongTap,
          onDoubleTap: widget.onDoubleTap,
        ),
      ),
    );
 
    

    if (widget.splashColor != null) {
      return Theme(
        data: Theme.of(context).copyWith(splashColor: widget.splashColor),
        child: w,
      );
    }

    return w;
  }
}

class IconTextRowButton extends StatelessWidget {
  final String icon;
  final String text;
  final Function onTap;
  final betweenHeight;

  const IconTextRowButton({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.betweenHeight = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformTapWidget(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Utils.loadImage(icon, ScreenUtil.getInstance().setHeight(100.0),ScreenUtil.getInstance().setHeight(100.0)),
          SizedBox(height: betweenHeight),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyles.listTitle,
          )
        ],
      ),
    );
  }
}

class IconTextColumnButton extends StatelessWidget {
  final String icon;
  final String text;
  final Function onTap;
  final betweenHeight;

  const IconTextColumnButton({
    Key key,
    this.icon,
    this.text,
    this.onTap,
    this.betweenHeight = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformTapWidget(
      onTap: onTap,
      child: Container(
        width: ScreenUtil.getInstance().setWidth(190.0),
        height: ScreenUtil.getInstance().setHeight(190.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Utils.loadImage(icon, ScreenUtil.getInstance().setWidth(90.0),ScreenUtil.getInstance().setHeight(90.0)),
            SizedBox(height: betweenHeight),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyles.listContent,
            )
          ],
        ),
      ),
    );
  }
}
