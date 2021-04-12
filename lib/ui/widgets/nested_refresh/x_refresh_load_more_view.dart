import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:neighbours/ui/widgets/nested_refresh/x_data_loader_base.dart';
import 'package:neighbours/ui/widgets/nested_refresh/x_empty_error_view.dart';
import 'package:neighbours/ui/widgets/nested_refresh/x_refresh_load_more_footer.dart';

/// 构造内容
typedef ContentBuilder = ScrollView Function(
    BuildContext context, DataLoadMoreBase dataLoader);

/// 上拉加载更多
class MyRefreshLoadMoreList extends StatefulWidget {
  //置顶
  final bool enableQuickTop;
  // 反向
  final bool reverse;
  // 方向
  final Axis direction;
  // Header浮动
  final bool headerFloat;
  // 无限加载
  // final bool enableInfiniteLoad = true;
  // 控制结束
  // final bool enableControlFinish = false;
  // 任务独立
  // final bool taskIndependence = false;
  // 震动
  // final bool vibration = true;
  // 是否开启刷新
  final bool enableRefresh;
  // 是否开启加载
  final bool enableLoad;
  // 顶部回弹
  final bool topBouncing;
  // 底部回弹
  final bool bottomBouncing;
  final ContentBuilder contentBuilder;
  final DataLoadMoreBase dataLoader;

  const MyRefreshLoadMoreList({
    Key key,
    @required this.dataLoader,
    @required this.contentBuilder,
    this.enableQuickTop: true,
    this.reverse: true,
    this.direction: Axis.vertical,
    this.headerFloat: false,
    this.enableRefresh: true,
    this.enableLoad: true,
    this.topBouncing: true,
    this.bottomBouncing: true,
  }) : super(key: key);

  @override
  _MyRefreshLoadMoreListState createState() => _MyRefreshLoadMoreListState();
}

class _MyRefreshLoadMoreListState extends State<MyRefreshLoadMoreList>
    with AutomaticKeepAliveClientMixin {
  /// 数据加载类
  DataLoadMoreBase _loader;
  EasyRefreshController _controller;
  ScrollController _scrollController;
  bool isShowQuickTop = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loader = widget.dataLoader;
    _controller = EasyRefreshController();
    _scrollController = ScrollController();
    _loader.init(_controller);
    _scrollController.addListener(() {
      int offset = _scrollController.offset.toInt();
      if (offset < 1000 && isShowQuickTop) {
        isShowQuickTop = false;
        setState(() {});
      } else if (offset > 1000 && !isShowQuickTop) {
        isShowQuickTop = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: EasyRefresh(
          enableControlFinishRefresh: false,
          enableControlFinishLoad: false,
          taskIndependence: false,
          controller: _controller,
          scrollController: _scrollController,
          topBouncing: widget.topBouncing,
          bottomBouncing: widget.bottomBouncing,
          header: MaterialHeader(),
          footer: MyFooter(),
          child: widget.contentBuilder(context, _loader),
          emptyWidget: _loader.isRefreshEmpty
              ? _loader.isRefreshError
                  ? MyEmptyErrorView('assets/images/nodata.png', "加载错误,点击重试",
                      () {
                      _controller.resetRefreshState();
                      _controller.callRefresh();
                    })
                  : MyEmptyErrorView('assets/images/nodata.png', "暂无数据", () {
                      _controller.resetRefreshState();
                      _controller.callRefresh();
                    })
              : null,
          firstRefresh: true,
          onRefresh: widget.enableRefresh
              ? () async {
                  // _controller.resetRefreshState();
                  await _loader.loadData(true);
                  // setState(() {});
                }
              : null,
          onLoad: widget.enableLoad &&
                  !_loader.isRefreshEmpty &&
                  !_loader.isRefreshError
              ? () async {
                  // _controller.resetLoadState();
                  await _loader.loadData(false);
                  // setState(() {});
                }
              : null,
        ),
        floatingActionButton: buildFloatingActionButton());
  }

  Widget buildFloatingActionButton() {
    return widget.enableQuickTop && isShowQuickTop ?? false
        ? FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.keyboard_arrow_up,
            ),
            onPressed: () {
              if (_scrollController != null) {
                _scrollController.animateTo(0.0,
                    duration: new Duration(microseconds: 1000),
                    curve: ElasticInCurve());
              }
            })
        : null;
  }
}
