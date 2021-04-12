import 'package:flutter/material.dart';

class MyEmptyErrorView extends StatelessWidget {
  final String imageIcon;
  final String showText;
  final GestureTapCallback onTap;

  const MyEmptyErrorView(this.imageIcon, this.showText, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: Image.asset(imageIcon),
            ),
            Text(
              showText,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
            ),
            Expanded(
              child: SizedBox(),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
