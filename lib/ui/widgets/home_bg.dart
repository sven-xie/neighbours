import 'package:flutter/material.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/utils/util_index.dart';

class LoginBackground extends StatelessWidget {
  final bgColor;
  final image;
  LoginBackground({this.bgColor = Colours.app_main, this.image});

  Widget topHalf(BuildContext context) {
    return new Container(
      height: ScreenUtil.getInstance().setHeight(650.0),
      child: ClipPath(
        clipper: new ArcClipper(),
        child: Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: [Colours.gray_99, Colours.gray_66],
              )),
            ),
            image == null
                ? new Center(
                    child: SizedBox(
                        height: ScreenUtil.getInstance().setHeight(100.0),
                        width: ScreenUtil.getInstance().setWidth(80.0),
                        child: new Container()),
                  )
                : new Container(
                    width: double.infinity,
                    child: image != null
                        ? Image.network(
                            image,
                            fit: BoxFit.cover,
                          )
                        : new Container())
          ],
        ),
      ),
    );
  }

  final bottomHalf = new Container(
    height: ScreenUtil.getInstance().setHeight(20.0),
    child: new Container(),
  );

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf],
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = new Offset(size.width / 4, size.height);
    var firstPoint = new Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height);
    var secondPoint = new Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
