import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:neighbours/ui/pages/shop/good_item.dart';
import 'package:neighbours/ui/widgets/loadmore/x_refresh_load_more.dart';
import 'package:neighbours/models/comments.dart';

class ShopTypeTissue extends StatefulWidget {
  @override
  _ShopTypeTissueState createState() => _ShopTypeTissueState();
}

class _ShopTypeTissueState extends State<ShopTypeTissue>
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
      slivers: <Widget>[
        SliverStaggeredGrid.countBuilder(
          itemCount: itemCount,
          crossAxisCount: 4,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          itemBuilder: (context, index) => new GoodItem(index),
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
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

    return true;
  }

  @override
  bool hasMore() => !isLoadEnd;
}
