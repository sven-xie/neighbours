import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neighbours/common/component_index.dart';
import 'package:neighbours/models/Model.dart';
import 'package:neighbours/models/comments.dart';
import 'package:neighbours/models/user_info.dart';
import 'package:neighbours/ui/commonwidgets/bottom_comment_bar.dart';
import 'package:neighbours/ui/commonwidgets/comment_common_view.dart';
import 'package:neighbours/ui/commonwidgets/user_common_bar.dart';
import 'package:neighbours/ui/widgets/loadmore/loader.dart';
import 'dart:async';
import 'package:neighbours/ui/widgets/nested_refresh/x_nested_refresh_load_more.dart';
import 'package:neighbours/ui/widgets/custom_sliver_delegate.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class CommentDetailPage extends StatefulWidget {
  @override
  _CommentDetailPageState createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends State<CommentDetailPage> {
  String _commentStr;
  List<String> menuList = ["关注", "屏蔽", "举报"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动态详情"),
        actions: <Widget>[
          PopupMenuButton<String>(
            padding: EdgeInsets.all(3.0),
            onSelected: (String menuName) {
              Utils.showToast(menuName);
            },
            itemBuilder: (BuildContext context) =>
                menuList.map((String menuName) {
              return new PopupMenuItem<String>(
                  value: menuName, child: Center(child: new Text(menuName)));
            }).toList(),
          ),
        ],
        elevation: 0,
      ),
      body: BoxWithBottomComment(
        child: Loader<Comment>(
            loadTask: () => _getCommentDetail(),
            builder: (context, result) {
              return _CommentDetailBody(result);
            }),
        commentStr: _commentStr,
      ),
    );
  }

  Future<Comment> _getCommentDetail() async {
    return Comment("headUrl", "user", "action", "time", "title", "mark", 2, 1);
  }
}

class _CommentDetailBody extends StatefulWidget {
  final Comment result;

  const _CommentDetailBody(this.result);
  @override
  _CommentDetailBodyState createState() => _CommentDetailBodyState();
}

class _CommentDetailBodyState extends State<_CommentDetailBody>
    with TickerProviderStateMixin {
  DataLoadMoreBase _dataLoader;
  List<Comment> list = [];
  int tabIndex = 0;
  List<String> menuList = ["关注", "屏蔽", "举报"];
  TabController _tabController;
  var _tabs = ["点赞", "评论", "收藏"];

  int _listCount = 10;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        tabIndex = _tabController.index;
        setState(() {});
      });

    _dataLoader = _DataLoader(0);
    super.initState();
    _dataLoader.loadData(true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dataLoader.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Text("askjdlfaj"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PullToRefreshNotification(
      onRefresh: onRefresh,
      child: extended.NestedScrollView(
        physics: ClampingScrollPhysics(),
        pinnedHeaderSliverHeightBuilder: () {
          return 0.0;
        },
        innerScrollPositionKeyBuilder: () {
          var index = "Tab";
          return Key(index + _tabController.index.toString());
        },
        headerSliverBuilder: (c, f) {
          var widgets = <Widget>[];
          widgets.add(
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Card(
                      color: Colours.white,
                      elevation: 0.0,
                      // margin: const EdgeInsets.only(top: 10.0),
                      child: Ink(
                        child: CContainer(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 8.0, bottom: 8.0),
                          onTap: () {
                            Application.router
                                .navigateTo(context, Routes.commentDetailPage);
                          },
                          child: new Column(
                            children: <Widget>[
                              CommonUserBar(
                                userInfo: UserInfo(
                                    nickname: "宋慧乔",
                                    avatarUrl:
                                        "https://pic3.zhimg.com/50/2b8be8010409012e7cdd764e1befc4d1_s.jpg"),
                                time: "一小时前",
                                address: "恒安国际广场",
                                onPopupMenuSelect: (String selectName) {
                                  Utils.showToast(selectName);
                                },
                              ),
                              CommonCommonView(),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          );

          widgets.add(
            SliverPersistentHeader(
              pinned: true,
              delegate: CustomSliverPersistentHeaderDelegate(
                min: 45.0,
                max: 45.0,
                builder: (context, state) => CContainer(
                  height: 45.0,
                  color: (state.isPinned ? Colours.app_main : Colours.white)
                      .withOpacity(1.0 - state.scrollPercentage),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TabBar(
                    indicatorColor:
                        (state.isPinned ? Colours.white : Colours.app_main)
                            .withOpacity(1.0 - state.scrollPercentage),
                    labelStyle: TextStyle(fontSize: 16),
                    unselectedLabelStyle: TextStyle(fontSize: 16),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text(
                          "评论",
                          style: TextStyle(
                              color: (state.isPinned
                                      ? Colours.white
                                      : Colours.text_title)
                                  .withOpacity(1.0 - state.scrollPercentage)),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "点赞",
                          style: TextStyle(
                              color: (state.isPinned
                                      ? Colours.white
                                      : Colours.text_title)
                                  .withOpacity(1.0 - state.scrollPercentage)),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "收藏",
                          style: TextStyle(
                              color: (state.isPinned
                                      ? Colours.white
                                      : Colours.text_title)
                                  .withOpacity(1.0 - state.scrollPercentage)),
                        ),
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
              ),
            ),
          );

          return widgets;
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((String name) {
            return extended.NestedScrollViewInnerScrollPositionKeyWidget(
              Key(name),
              // RefreshLoadMoreList(topBouncing: false,enableRefresh: false,dataLoader: _dataLoader,contentBuilder: _contentBuilder4,),

              EasyRefresh(
                topBouncing: false,
                footer: MyFooter(),
                child: CustomScrollView(
                  // physics: ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Column(
                            children: <Widget>[
                              Container(height: 100.0, child: Text("点赞"))
                            ],
                          );
                        },
                        childCount: 10,
                      ),
                    ),
                  ],
                ),
                onRefresh: null,
                onLoad: () async {
                  await Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      _listCount += 10;
                    });
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    ));
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    list.clear();
  }

  CustomScrollView _contentBuilder4(
      BuildContext context, DataLoadMoreBase dataLoader) {
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: <Widget>[Container(height: 100.0, child: Text("点赞"))],
              );
            },
            childCount: _listCount,
          ),
        ),
      ],
    );
  }
}

/// 数据业务逻辑处理
class _DataLoader extends DataLoadMoreBase<Comment, Model> {
  int _id; // 请求时的参数

  _DataLoader(this._id);

  @override
  Future<Model> getRequest(
      bool isRefresh, int currentPage, int pageSize) async {
    await Future.delayed(Duration(seconds: 1));

    // if (currentPage == 1 && Random().nextBool()) {
    //   return Model(data: List(), message: "加载成功", code: 0);
    // }

    // if (Random().nextBool()) {
    //   return Model(data: null, message: "加载失败", code: 1);
    // }

    // if (currentPage == 4) {
    //   return Model(
    //       data: new List.of(articleList.sublist(0, 2)),
    //       message: "加载成功",
    //       code: 0);
    // }

    return Model(data: new List.of(articleList), message: "加载成功", code: 0);
  }
}
