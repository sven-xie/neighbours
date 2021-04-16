import 'package:flutter/material.dart';
import 'package:neighbours/common/component_index.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _status = 0;

  @override
  void initState() {
    super.initState();

    Observable.just(1).delay(new Duration(milliseconds: 2000)).listen((_) {
      _goMain();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: !(_status == 0),
            child: _buildSplashBg(),
          )
        ],
      ),
    );
  }

  Widget _buildSplashBg() {
    return new Image.asset(Utils.getImgPath("splash_bg"),
        width: double.infinity, height: double.infinity, fit: BoxFit.fill);
  }

  void _goMain() {
    Application.router.navigateTo(context, Routes.mainPage, clearStack: true);
  }
}
