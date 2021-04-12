import 'package:flutter/cupertino.dart';
import 'package:neighbours/common/component_index.dart';
import 'package:neighbours/ui/commonwidgets/x_photo_view_browser.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {
  static void pushPage(BuildContext context, Widget page, {String pageName}) {
    if (context == null || page == null || ObjectUtil.isEmpty(pageName)) return;
    Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

  static void pushWeb(BuildContext context,
      {String title, String titleId, String url, bool isHome: false}) {
    if (context == null || ObjectUtil.isEmpty(url)) return;
    if (url.endsWith(".apk")) {
      launchInBrowser(url, title: title ?? titleId);
    } else {
      Navigator.push(
          context,
          new CupertinoPageRoute<void>(
              builder: (ctx) => new WebScaffold(
                    title: title,
                    titleId: titleId,
                    url: url,
                  )));
    }
  }

  static void pushPhotoViewBrowser(
    BuildContext context, {
    List<String> pics,
    int currentIndex,
  }) {
    if (context == null || ObjectUtil.isEmpty(pics)) return;
    Navigator.push(
        context,
        new CupertinoPageRoute<void>(
            builder: (ctx) => new XPhotoViewBrowser(
                  pics: pics,
                  currentIndex: currentIndex,
                )));
  }

  // static void pushTabPage(BuildContext context,
  //     {String labelId, String title, String titleId, TreeModel treeModel}) {
  //   if (context == null) return;
  //   Navigator.push(
  //       context,
  //       new CupertinoPageRoute<void>(
  //           builder: (ctx) => new BlocProvider<TabBloc>(
  //                 child: new TabPage(
  //                   labelId: labelId,
  //                   title: title,
  //                   titleId: titleId,
  //                   treeModel: treeModel,
  //                 ),
  //                 bloc: new TabBloc(),
  //               )));
  // }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
