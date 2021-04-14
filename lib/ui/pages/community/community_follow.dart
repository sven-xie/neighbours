import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neighbours/common/component_index.dart';
import 'package:neighbours/models/Model.dart';
import 'package:neighbours/models/user_info.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/ui/commonwidgets/comment_common_view.dart';
import 'package:neighbours/ui/commonwidgets/user_common_bar.dart';
import 'package:neighbours/ui/widgets/loadmore/x_refresh_load_more.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:neighbours/utils/utils.dart';
import 'package:neighbours/models/comments.dart';

class CommunityFollow extends StatefulWidget {
  @override
  _CommunityFollowState createState() => _CommunityFollowState();
}

class _CommunityFollowState extends State<CommunityFollow>
    with AutomaticKeepAliveClientMixin {
  int get count => list.length;
  List<Comment> list = [];
  DataLoadMoreBase _dataLoader;

  @override
  void initState() {
    _dataLoader = _DataLoader(1);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // return RefreshLoadMoreList(
    //   dataLoader: _dataLoader,
    //   contentBuilder: _contentBuilder,
    //   // isNestWrapped: true,
    // );
    return RefreshLoadMoreList(
      enableQuickTop: true,
      enablePullDown: true,
      enablePullUp: true,
      contentBuilder: _contentBuilder,
      dataLoader: _dataLoader,
    );
  }

  CustomScrollView _contentBuilder(
      BuildContext context, DataLoadMoreBase dataLoader) {
    // var itemCount = dataLoader.length;
    return CustomScrollView(
      key: PageStorageKey<String>("community_follow"),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return wordsCard(dataLoader[index]);
            },
            childCount: dataLoader.length,
          ),
        )
      ],
    );
  }

  Widget wordsCard(Comment article) {
    // Widget markWidget;
    // if (article.imgUrl == null) {
    //   markWidget = new Text(article.mark,
    //       style: new TextStyle(height: 1.3, color: Colours.gray_66));
    // } else {
    //   markWidget = new Row(
    //     children: <Widget>[
    //       new Expanded(
    //         flex: 2,
    //         child: new Container(
    //           child: new Text(article.mark,
    //               style: new TextStyle(height: 1.3, color: Colours.gray_66)),
    //         ),
    //       ),
    //       new Expanded(
    //           flex: 1,
    //           child: new AspectRatio(
    //               aspectRatio: 3.0 / 2.0,
    //               child: new Container(
    //                 foregroundDecoration: new BoxDecoration(
    //                     image: new DecorationImage(
    //                       image: new NetworkImage(article.imgUrl),
    //                       centerSlice:
    //                           new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
    //                     ),
    //                     borderRadius:
    //                         const BorderRadius.all(const Radius.circular(6.0))),
    //               ))),
    //     ],
    //   );
    // }
    List<String> menuList = ["关注", "屏蔽", "举报"];
    return Card(
        color: Colours.white,
        elevation: 0.0,
        margin: const EdgeInsets.only(top: 10.0),
        child: Ink(
          child: CContainer(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
            onTap: () {
              Application.router.navigateTo(context, Routes.commentDetailPage);
            },
            child: new Column(
              children: <Widget>[
                CommonUserBar(
                  userInfo: UserInfo(
                      nickname: article.user, avatarUrl: article.headUrl),
                  time: "一小时前",
                  address: "恒安国际广场",
                  menuList: menuList,
                  onPopupMenuSelect: (String selectName) {
                    Utils.showToast(selectName);
                  },
                ),
                CommonCommonView(),
              ],
            ),
          ),
        ));
  }

  Widget billboard() {
    return new Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: Colours.app_bg,
        child: new FlatButton(
          onPressed: () {},
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                      child: new CircleAvatar(
                          backgroundImage: new NetworkImage(
                              "https://pic1.zhimg.com/50/v2-0c9de2012cc4c5e8b01657d96da35534_s.jpg"),
                          radius: 11.0),
                    ),
                    new Text("  对啊网",
                        style: new TextStyle(color: Colours.gray_66))
                  ],
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                  child: new Text("考过CPA，非名牌大学也能进名企",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          height: 1.3,
                          color: Colors.black)),
                  margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                  alignment: Alignment.topLeft),
              new Container(
                  child: new AspectRatio(
                      aspectRatio: 3.0 / 1.0,
                      child: new Container(
                        foregroundDecoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(
                                  "https://pic2.zhimg.com/50/v2-6416ef6d3181117a0177275286fac8f3_hd.jpg"),
                              centerSlice: new Rect.fromLTRB(
                                  270.0, 180.0, 1360.0, 730.0),
                            ),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(6.0))),
                      )),
                  margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                  alignment: Alignment.topLeft),
              new Container(
                  child: new Text("还在羡慕别人的好工作？免费领取价值1980元的注册会计师课程，为自己充电！",
                      style:
                          new TextStyle(height: 1.3, color: Colours.gray_66)),
                  padding: const EdgeInsets.only(bottom: 8.0)),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Container(
                        child: new Text("广告",
                            style: new TextStyle(
                                fontSize: 10.0, color: Colours.gray_66)),
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colours.gray_66),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(2.0)),
                        ),
                        padding: const EdgeInsets.only(
                            top: 2.0, bottom: 2.0, left: 3.0, right: 3.0)),
                    new Expanded(
                        child: new Text("  查看详情",
                            style: new TextStyle(color: Colours.gray_66))),
                    new Icon(Icons.clear, color: Colours.gray_66)
                  ],
                ),
                padding: const EdgeInsets.only(bottom: 10.0),
              )
            ],
          ),
        ));
  }
}

/// 数据业务逻辑处理
class _DataLoader extends DataLoadMoreBase<Comment, Model> {
  bool _hasMore = true;
  int _id; // 请求时的参数

  _DataLoader(this._id);

  @override
  Future<Model> getRequest(
      bool isRefresh, int currentPage, int pageSize) async {
    await Future.delayed(Duration(seconds: 2));

    if (currentPage == 1 && Random().nextBool()) {
      return Model(data: List(), message: "加载成功", code: 0);
    }

    if (Random().nextBool()) {
      return Model(data: null, message: "加载失败", code: 1);
    }

    if (currentPage == 4) {
      return Model(
          data: new List.of(articleList.sublist(0, 2)),
          message: "加载成功",
          code: 0);
    }

    // if (currentPage == 4) {
    //   return Model(
    //       data: new List.of(articleList.sublist(0, 2)),
    //       message: "加载成功",
    //       code: 0);
    // }

    return Model(data: new List.of(articleList), message: "加载成功", code: 0);
  }

  @override
  Future<bool> handlerData(Model model, bool isRefresh) async {
    if (model == null || model.isError()) {
      return false;
    }

    if (isRefresh) clear();

    // todo 实际使用时这里需要修改
    addAll((model.data as List<dynamic>).map((d) {
      return d as Comment;
    }));
    return true;
  }

  @override
  bool hasMore() {
    return _hasMore;
  }
}
