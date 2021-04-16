import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:neighbours/base/_base_widget.dart';
import 'package:neighbours/common/component_index.dart';
import 'package:neighbours/ui/pages/search/search_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/models/home_model.dart';
import 'package:neighbours/ui/widgets/button/button_widget.dart';
import 'package:neighbours/ui/widgets/loadmore/refresh_safe_area.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/all_round_refresher.dart';
import 'package:neighbours/ui/widgets/pullloadmore/pull_load_more_view.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:neighbours/ui/pages/home/home_section.dart';
import 'package:neighbours/ui/widgets/image/n_image.dart';
import 'package:neighbours/ui/widgets/n_sliver.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

List<String> _bannerList = [
  "https://img95.699pic.com/photo/40007/4125.jpg_wh300.jpg",
  "https://cdn.pixabay.com/photo/2016/10/21/14/50/plouzane-1758197_960_720.jpg",
  "https://img.zcool.cn/community/01cbf45d91c5e7a8012060be33e1a4.jpg@1280w_1l_2o_100sh.jpg",
  "https://cdn.pixabay.com/photo/2016/11/16/10/59/mountains-1828596_960_720.jpg",
  "https://cdn.pixabay.com/photo/2013/01/17/08/25/sunset-75159_960_720.jpg",
  "https://cdn.pixabay.com/photo/2016/11/16/10/59/mountains-1828596_960_720.jpg"
];
List<Widget> _commentList = [
  new _Tile(
      'https://cdn.pixabay.com/photo/2016/10/21/14/50/plouzane-1758197_960_720.jpg',
      1),
  new _Tile(
      'https://cdn.pixabay.com/photo/2016/11/16/10/59/mountains-1828596_960_720.jpg',
      2),
  new _Tile(
      'https://cdn.pixabay.com/photo/2013/01/17/08/25/sunset-75159_960_720.jpg',
      3),
  new _Tile(
      'https://cdn.pixabay.com/photo/2016/10/21/14/50/plouzane-1758197_960_720.jpg',
      4),
  new _Tile(
      'https://cdn.pixabay.com/photo/2016/11/16/10/59/mountains-1828596_960_720.jpg',
      5),
  new _Tile(
      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1463049146,1927096897&fm=26&gp=0.jpg',
      6),
  new _Tile(
      'https://cdn.pixabay.com/photo/2017/08/24/22/37/gyrfalcon-2678684_960_720.jpg',
      7),
  new _Tile(
      'https://cdn.pixabay.com/photo/2013/01/17/08/25/sunset-75159_960_720.jpg',
      8),
  new _Tile(
      'https://cdn.pixabay.com/photo/2017/08/24/22/37/gyrfalcon-2678684_960_720.jpg',
      9),
];
List<String> str = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
List<String> addStr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

class HomePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return HomePageState();
  }
}

class HomePageState extends BaseWidgetState<HomePage> {
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      title: new Text("恒安国际广场"),
      bottom: null,
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
              showSearch(context: context, delegate: SearchBarDelegate());
            })
      ],
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return HomeMainPage();
  }

  @override
  void onClickErrorWidget() {}
}

class HomeMainPage extends StatefulWidget {
  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int get count => list.length;
  List<int> list = [];
  List<String> _tipList = ["尿不湿开年大优惠", "小区消毒工作进行中。。", "小区物业费该交了", "祝贺全体业主新春愉快"];
  List<MenuInfo> _menuList = new List();
  double headerContentHeight = ScreenUtil.statusBarHeight;
  RefreshController _controller;

  @override
  void initState() {
    _controller = RefreshController();
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.white,
      child: PullLoadMoreView(
        controller: _controller,
        // isNestWrapped: true,
        enablePullUp: false,
        onLoading: _loadMore,
        onRefresh: _refresh,
        child: CustomScrollView(slivers: <Widget>[
          SliverToBoxAdapter(
            child: _getHeadView(),
          ),
          _getMarqueeView(),
          _getEmptyDivider(),
          _getDivider(),
          _getGoodsWidget("优惠商品"),
          _getEmptyDivider(),
          _getDivider(),
          _getCommentsWidget("精选动态"),
        ]),
      ),
    );
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    load();
    return true;
  }

  void load() {
    setState(() {
      list.addAll(List.generate(15, (v) => v));
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    list.clear();
    load();
    _controller.refreshCompleted();
  }

  Widget _getFunctionBars() {
    _menuList.add(
        MenuInfo(title: "访客", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "车位", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "联系管家", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "缴费", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "报修", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "社区", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "建议", url: "", imagePath: "assets/images/wuye.png"));
    _menuList.add(
        MenuInfo(title: "商城", url: "", imagePath: "assets/images/wuye.png"));

//  return HomeMenu(_menuList);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: _menuList.getRange(0, 4).map((MenuInfo menu) {
                        return IconTextColumnButton(
                          icon: menu.imagePath,
                          text: menu.title,
                          onTap: () {
                            Utils.showToast(menu.title);
                          },
                        );
                      }).toList()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: _menuList.getRange(4, 8).map((MenuInfo menu) {
                        return IconTextColumnButton(
                          icon: menu.imagePath,
                          text: menu.title,
                          onTap: () {
                            Utils.showToast(menu.title);
                          },
                        );
                      }).toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMarqueeView() {
    return SliverToBoxAdapter(
        child: CContainer(
      color: Colours.white,
      height: 30.0,
      padding: EdgeInsetsDirectional.only(
          start: 15.0, top: 5.0, end: 15.0, bottom: 5.0),
      direction: Direction.row,
      children: <Widget>[
        CText(
          "公告",
          textSize: 14,
          imageAsset: Utils.getImgPath("home_tip"),
          imageScale: 1.2,
          drawableDirection: DrawableDirection.left,
          drawablePadding: 10,
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: RefreshSafeArea(
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Center(child: Text(_tipList[index]));
              },
              scrollDirection: Axis.vertical,
              itemCount: _tipList.length,
              autoplay: true,
            ),
          ),
        )),
      ],
    ));
  }

  SliverPersistentHeader _buildStickHeader(String title) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverAppBarDelegate(
        minHeight: ScreenUtil.getInstance().setHeight(100.0),
        maxHeight: ScreenUtil.getInstance().setHeight(100.0),
        child: HomeSectionView(title, () {}),
      ),
    );
  }

  Widget _getHeadView() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: ScreenUtil.getInstance().setHeight(450.0),
                child: RefreshSafeArea(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return CacheImgRadius(
                          imgUrl: _bannerList[index], radius: 0);
                    },
                    pagination: new SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                      color: Colours.transparent_80,
                      activeColor: Colours.white,
                      activeSize: 6.0,
                      size: 6.0,
                    )),
                    scrollDirection: Axis.horizontal,
                    itemCount: _bannerList.length,
                    viewportFraction: 1,
                    scale: 1,
                    autoplay: true,
                  ),
                )),
            // SizedBox(height: 5,),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              0, ScreenUtil.getInstance().setHeight(400.0), 0, 0),
          child: _getFunctionBars(),
        ),
      ],
    );
  }
}

Widget _getEmptyDivider() {
  return SliverToBoxAdapter(
    child: SizedBox(
      height: 15.0,
    ),
  );
}

Widget _getDivider() {
  return SliverToBoxAdapter(
    child: Container(
      width: double.infinity,
      height: 15.0,
      color: Colours.app_bg,
    ),
  );
}

Widget _getGoodsWidget(String title) {
  return SliverStickyHeaderBuilder(
    builder: (context, state) => HomeSectionView(
        title,
        () => Scaffold.of(context)
            .showSnackBar(new SnackBar(content: Text(title)))),
    sliver: SliverGrid.count(
      // physics: new NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      // shrinkWrap: true,
      children: str
          .map((product) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  splashColor: Colors.yellow,
                  onTap: () => showSnackBar(),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    elevation: 2.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        imageStack(
                            "https://img.zcool.cn/community/01cbf45d91c5e7a8012060be33e1a4.jpg@1280w_1l_2o_100sh.jpg"),
                        descStack(),
                        ratingStack(4.5),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    ),
  );
}

Widget _getCommentsWidget(String title) {
  return SliverStickyHeaderBuilder(
    builder: (context, state) => HomeSectionView(
        title,
        () => Scaffold.of(context)
            .showSnackBar(new SnackBar(content: Text(title)))),
    sliver: new SliverStaggeredGrid.countBuilder(
      itemCount: _commentList.length,
      crossAxisCount: 4,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      itemBuilder: (context, index) => _commentList[index],
      staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
    ),
  );
}

//stack1
Widget imageStack(String img) => Image.network(
      img,
      fit: BoxFit.cover,
    );

//stack2
Widget descStack() => Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  "心心相印",
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text("￥ 6.8",
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );

//stack3
Widget ratingStack(double rating) => Positioned(
      top: 0.0,
      left: 0.0,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.star,
              color: Colors.cyanAccent,
              size: 10.0,
            ),
            SizedBox(
              width: 2.0,
            ),
            Text(
              rating.toString(),
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            )
          ],
        ),
      ),
    );

Widget productGrid() => SliverGrid.count(
      // physics: new NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      // shrinkWrap: true,
      children: str
          .map((product) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  splashColor: Colors.yellow,
                  onTap: () => showSnackBar(),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    elevation: 2.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        imageStack(
                            "https://img.zcool.cn/community/01cbf45d91c5e7a8012060be33e1a4.jpg@1280w_1l_2o_100sh.jpg"),
                        descStack(),
                        ratingStack(4.5),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );

final scaffoldKey = GlobalKey<ScaffoldState>();
void showSnackBar() {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      "Added to cart.",
    ),
    action: SnackBarAction(
      label: "Undo",
      onPressed: () {},
    ),
  ));
}

class _Tile extends StatelessWidget {
  const _Tile(this.source, this.index);

  final String source;
  final int index;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          Utils.loadImageSpecified(source),
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
                new Text(
                  'Image number $index',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  'Vincent Van Gogh',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
