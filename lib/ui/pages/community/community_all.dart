import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/ui/pages/home/home_section.dart';
import 'package:neighbours/ui/widgets/loadmore/x_refresh_load_more.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:neighbours/utils/utils.dart';
import 'package:neighbours/models/comments.dart';

class CommunityAll extends StatefulWidget {
  @override
  _CommunityAllState createState() => _CommunityAllState();
}

class _CommunityAllState extends State<CommunityAll>
    with AutomaticKeepAliveClientMixin {
  int get count => list.length;
  List<Comment> list = [];
  DataLoadMoreBase _dataLoader;

  @override
  void initState() {
    _dataLoader = _DataLoader(0);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return RefreshLoadMoreList(
      dataLoader: _dataLoader,
      contentBuilder: _contentBuilder,
      // isNestWrapped: true,
    );
  }

  ScrollView _contentBuilder(
      BuildContext context, DataLoadMoreBase dataLoader) {
    var itemCount = dataLoader.length;

    return CustomScrollView(
      key: PageStorageKey<String>("community_all"),
      slivers: <Widget>[
        // SliverOverlapInjector(
        //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        // ),
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              HomeSectionView(
                  "热门话题",
                  () => Scaffold.of(context).showSnackBar(new SnackBar(
                          content: CText(
                        "热门话题",
                        textSize: 14,
                        bold: true,
                      )))),
              Container(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 8) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("查看更多"),
                        ),
                      );
                    }
                    return _buildPlaylistItem(context);
                  },
                  itemCount: 9,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Container(
              //   width: double.infinity,
              //   height: 15.0,
              //   color: Colours.app_bg,
              // ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return wordsCard(dataLoader[index]);
            },
            childCount: itemCount,
          ),
        )
      ],
    );
  }

  Widget _buildPlaylistItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Utils.showToast("话题。。。。");
      },
      child: Container(
        width: 100,
        padding: EdgeInsetsDirectional.only(start: 10),
        child: Column(
          children: <Widget>[
            Img(
              "https://cdn.pixabay.com/photo/2016/11/16/10/59/mountains-1828596_960_720.jpg",
              radius: 2,
              width: 100,
              height: 90,
            ),
            Padding(padding: EdgeInsets.only(top: 2)),
            Container(
              width: 80,
              child: Text(
                "血拼到底，哈哈接电话发快捷地方哈就开始的合法",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.listExtra,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wordsCard(Comment article) {
    Widget markWidget;
    if (article.imgUrl == null) {
      markWidget = new Text(article.mark,
          style: new TextStyle(height: 1.3, color: Colours.gray_66));
    } else {
      markWidget = new Row(
        children: <Widget>[
          new Expanded(
            flex: 2,
            child: new Container(
              child: new Text(article.mark,
                  style: new TextStyle(height: 1.3, color: Colours.gray_66)),
            ),
          ),
          new Expanded(
              flex: 1,
              child: new AspectRatio(
                  aspectRatio: 3.0 / 2.0,
                  child: new Container(
                    foregroundDecoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(article.imgUrl),
                          centerSlice:
                              new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                        ),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(6.0))),
                  ))),
        ],
      );
    }
    return Container(
      color: Colours.app_bg,
      child: new Container(
          color: Colours.white,
          margin: const EdgeInsets.only(top: 10.0),
          child: new FlatButton(
            onPressed: () {
              Utils.showToast("点击了动态");
            },
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: new CircleAvatar(
                            backgroundImage: new NetworkImage(article.headUrl),
                            radius: 11.0),
                      ),
                      new Text(
                          "  " +
                              article.user +
                              " " +
                              article.action +
                              " · " +
                              article.time,
                          style: new TextStyle(color: Colours.gray_66))
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 10.0),
                ),
                new Container(
                    child: new Text(article.title,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.3,
                            color: Colors.black)),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft),
                new Container(
                    child: markWidget,
                    margin: new EdgeInsets.only(top: 6.0),
                    alignment: Alignment.topLeft),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                              article.agreeNum.toString() +
                                  " 赞同 · " +
                                  article.commentNum.toString() +
                                  "评论",
                              style: new TextStyle(color: Colours.gray_66))),
                      new PopupMenuButton(
                          icon: new Icon(
                            Icons.linear_scale,
                            color: Colours.gray_66,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<String>>[
                                new PopupMenuItem<String>(
                                    value: '选项一的值', child: new Text('屏蔽这个问题')),
                                new PopupMenuItem<String>(
                                    value: '选项二的值',
                                    child: new Text('取消关注 learner')),
                                new PopupMenuItem<String>(
                                    value: '选项二的值', child: new Text("举报"))
                              ])
                    ],
                  ),
                  padding: const EdgeInsets.only(),
                )
              ],
            ),
          )),
    );
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

class _DataLoader extends DataLoadMoreBase<Comment, Model> {
  bool _hasMore = true;

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

  @override
  Future<bool> handlerData(Model model, bool isRefresh) async {
    // 1. 判断是否有业务错误,
    // 2. 将数据存入列表, 如果是刷新清空数据
    // 3. 判断是否有更多数据
    if (model == null || model.isError()) {
      return false;
    }

    if (isRefresh) clear();

    // todo 实际使用时这里需要修改
    addAll((model.data as List<dynamic>).map((d) {
      return d as Comment;
    }));
    // addDatas(model.data);

    // _hasMore = length < 20;

    return true;
  }

  @override
  bool hasMore() => _hasMore;
}
