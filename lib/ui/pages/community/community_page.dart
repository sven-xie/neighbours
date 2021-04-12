import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/models/comments.dart';
import 'package:neighbours/models/user_info.dart';
import 'package:neighbours/res/colors.dart';
import 'package:neighbours/routers/application.dart';
import 'package:neighbours/routers/routes.dart';
import 'package:neighbours/ui/commonwidgets/comment_common_view.dart';
import 'package:neighbours/ui/commonwidgets/user_common_bar.dart';
import 'package:neighbours/ui/pages/community/community_all.dart';
import 'package:neighbours/ui/pages/community/community_follow.dart';
import 'dart:ui';
import 'package:neighbours/ui/pages/search/search_page.dart';
import 'package:neighbours/ui/widgets/c_container.dart';
import 'package:neighbours/ui/widgets/custom_sliver_delegate.dart';
import 'package:neighbours/utils/util_index.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  int get count => list.length;
  List<Comment> list = [];
  TabController _tabController;
  ScrollController scrollController = ScrollController();
  var _tabs = ["探索", "关注"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // SliverOverlapAbsorber(
            //     handle:
            //         NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            //     child: new SliverToBoxAdapter(
            //       child: null,
            //     )),

            new SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              title: new Text("鱼塘"),
              elevation: 3,
              leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: SearchBarDelegate());
                    })
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 45.0),
                child: Container(
                  height: 45.0,
                  child: TabBar(
                    indicatorColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 16),
                    unselectedLabelStyle: TextStyle(fontSize: 16),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: "探索",
                      ),
                      Tab(text: "关注"),
                    ],
                    controller: _tabController,
                  ),
                ),
              ),
            ),
            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: CustomSliverPersistentHeaderDelegate(
            //     min: 45.0,
            //     max: 45.0,
            //     builder: (context, state) => CContainer(
            //           height: 45.0,
            //           color: Colours.common_orange,
            //           padding: EdgeInsets.only(left: 10.0, right: 10.0),
            //         ),
            //   ),
            // ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            new CommunityAll(),
            new CommunityFollow(),
          ],
          // children: _tabs.map((String name) {
          //   return RefreshIndicator(
          //       onRefresh: _refresh,
          //       child: CustomScrollView(
          //         key: PageStorageKey<String>(name),
          //         slivers: <Widget>[
          //           // SliverOverlapInjector(
          //           //   handle:
          //           //       NestedScrollView.sliverOverlapAbsorberHandleFor(
          //           //           context),
          //           // ),
          //           // SliverPadding(
          //           //   padding: const EdgeInsets.all(8.0),
          //           //   sliver: SliverFixedExtentList(
          //           //     itemExtent: 48.0,
          //           //     delegate: SliverChildBuilderDelegate(
          //           //       (BuildContext context, int index) {
          //           //         return ListTile(
          //           //           title: Text('Item $index'),
          //           //         );
          //           //       },
          //           //       childCount: 100,
          //           //     ),
          //           //   ),
          //           // ),

          //           SliverToBoxAdapter(
          //             child: Container(
          //               height: 200,
          //               color: Colours.common_orange,
          //             ),
          //           ),

          //           SliverList(
          //             delegate: SliverChildBuilderDelegate(
          //               (BuildContext context, int index) {
          //                 return wordsCard(articleList[0]);
          //               },
          //               childCount: 100,
          //             ),
          //           ),
          //         ],
          //       ));
          // }).toList(),
        ),
      ),
    );
    // return NestedScrollView(
    //   body: TabBarView(controller: _tabController, children: <Widget>[
    //     new CommunityAll(),
    //     new CommunityFollow(),
    //   ]),
    //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //     return <Widget>[
    //       new SliverAppBar(
    //         floating: true,
    //         pinned: true,
    //         snap: true,
    //         title: new Text("鱼塘"),
    //         elevation: 3,
    //         // flexibleSpace: Container(
    //         //   height: 300,
    //         //   color: Colors.red,
    //         // ),
    //         // expandedHeight: 300,
    //         leading: IconButton(
    //             icon: Icon(Icons.menu),
    //             onPressed: () {
    //               Scaffold.of(context).openDrawer();
    //             }),
    //         actions: <Widget>[
    //           IconButton(
    //               icon: Icon(Icons.search),
    //               onPressed: () {
    //                 showSearch(context: context, delegate: SearchBarDelegate());
    //               })
    //         ],
    //         bottom: PreferredSize(
    //           preferredSize: Size(double.infinity, 45.0),
    //           child: Container(
    //             height: 45.0,
    //             child: TabBar(
    //               indicatorColor: Colors.white,
    //               labelStyle: TextStyle(fontSize: 16),
    //               unselectedLabelStyle: TextStyle(fontSize: 16),
    //               isScrollable: true,
    //               tabs: [
    //                 Tab(
    //                   text: "探索",
    //                 ),
    //                 Tab(text: "关注"),
    //               ],
    //               controller: _tabController,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ];
    //   },
    // );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    // list.clear();
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

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._container);

  final Container _container;

  @override
  double get minExtent => 45;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _container,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
