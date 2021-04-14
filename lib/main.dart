import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/common/component_index.dart';
import 'package:neighbours/ui/pages/splash_page.dart';
import 'package:neighbours/routers/application.dart';
import 'package:neighbours/routers/routes.dart';

void main() => runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(bloc: MainBloc(), child: MyApp()),
    ));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  Color _themeColor = Colours.app_main;

  @override
  void initState() {
    super.initState();
    final router = new FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateRoute: Application.router.generator,
      home: new SplashPage(),
      theme: ThemeData.light().copyWith(
          primaryColor: _themeColor,
          accentColor: _themeColor,
          backgroundColor: Colours.app_bg,
          indicatorColor: Colors.white),
    );
  }
}
