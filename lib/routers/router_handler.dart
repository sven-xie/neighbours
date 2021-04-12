import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:neighbours/ui/commonwidgets/x_photo_view_browser.dart';
import 'package:neighbours/ui/pages/community/comment_detail.dart';
import 'package:neighbours/ui/pages/main_page.dart';
import 'package:neighbours/ui/pages/search/search_page.dart';


Handler mainPageHandler =Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    // String goodsId = params['id'].first;
    // print('index>details goodsID is ${goodsId}');
    return MainPage();

  }
);

Handler searchHandler =Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    // String goodsId = params['id'].first;
    // print('index>details goodsID is ${goodsId}');
    return SearchPage();

  }
);



Handler photoViewBrowserHandler =Handler(
  handlerFunc: (BuildContext context,Map<String,dynamic> params){
     print('XPhotoViewBrowser is ${params['pics']} ; ${params['currentIndex']}');
    // return XPhotoViewBrowser(currentIndex: params['currentIndex'].first);
    return XPhotoViewBrowser(pics: ["https://pic3.zhimg.com/v2-b67be50be51e2e6d6112a64528683b09_b.jpg","https://pic4.zhimg.com/v2-a7493d69f0d8f849c6345f8f693454f3_200x112.jpg"],currentIndex:0);
  }
);


Handler commentDetailHandler =Handler(
  handlerFunc: (BuildContext context,Map<String,dynamic> params){
    return CommentDetailPage();
  }
);