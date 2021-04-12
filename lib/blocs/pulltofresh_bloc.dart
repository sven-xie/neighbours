import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/blocs/bloc_index.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/indicator/bezer_header.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/flutter_allroundrefresh.dart';

///
///list列表
///author:chentong
///
abstract class SmartRefreshBloc extends PullToRefreshBloc {
  RefreshController refreshController;
  ScrollController scrollController;

  ///初始化
  void initState() {
    scrollController = new ScrollController();
    refreshController = new RefreshController();
  }

  void scrollTop() {
    scrollController.animateTo(0.0,
        duration: new Duration(microseconds: 1000), curve: ElasticInCurve());
  }

  void onRefreshCallBack(bool up) {
    if (up) {
      onRefresh();
    } else {
      onLoadMore();
    }
  }

  ///默认方法
  void onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
    if (isUp) {
    } else {}
  }

  ///开始刷新请求
  void refreshRequest({bool up = true}) {
    refreshController.requestRefresh();
  }

  ///刷新完成
  void refreshCompleted() {
    refreshController.refreshCompleted();
  }

  ///空闲
  void refreshIdle() {
    refreshController.refreshCompleted();
    refreshController.loadComplete();
  }

  ///刷新失败
  void refreshFailed() {
    refreshController.refreshFailed();
  }

  void loadMoreCompleted() {
    refreshController.loadComplete();
  }

   void requestLoading() {
    refreshController.requestLoading();
  }

   void loadDataError() {
    refreshController.loadDataError();
  }

   void loadNoData() {
    refreshController.loadNoData();
  }

  ///自定义头部
  Widget headerCreate() {
    return new WaterDropHeader();
  }

  @override
  void dispose() {}
}

///下拉刷新Bloc
abstract class PullToRefreshBloc extends BlocBase {
  ///加载数据
  Future getData({String labelId, int page});

  ///刷新
  Future onRefresh({String labelId});

  ///更多
  Future onLoadMore({String labelId, int page});
}
