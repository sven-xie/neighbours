import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes{
  static String root='/';
  static String mainPage = '/main_page';
  static String searchPage = '/search';
  static String commentDetailPage = '/community/comment_detail';
  static String phototViewPage = '/photoview';
  static void configureRoutes(Router router){
    router.notFoundHandler= new Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print('ERROR====>ROUTE WAS NOT FONUND!!!');
      }
    );

    router.define(mainPage,handler:mainPageHandler);
    router.define(searchPage,handler:searchHandler);
    router.define(commentDetailPage,handler:commentDetailHandler);
    router.define(phototViewPage,handler:photoViewBrowserHandler);
  }

}