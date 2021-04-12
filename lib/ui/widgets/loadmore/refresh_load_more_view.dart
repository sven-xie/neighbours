import 'package:flutter/material.dart';
import 'package:neighbours/ui/widgets/loadmore/load_more_indicator.dart';
import 'package:neighbours/ui/widgets/loadmore/loading_more_base.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/internals/refresh_physics.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/proview/proqress_view.dart';

/// 构造内容
typedef ContentBuilder = ScrollView Function(
    BuildContext context, DataLoadMoreBase dataLoader);

/// 上拉加载更多
class RefreshLoadMoreList extends StatefulWidget {
  final bool enableQuickTop;
  final bool isNestWrapped;
  final bool enableOverScroll;
  final int itemType;
  final bool enablePullDown;
  final bool enablePullUp;
  final ContentBuilder contentBuilder;
  final DataLoadMoreBase dataLoader;

  const RefreshLoadMoreList({
    Key key,
    @required this.dataLoader,
    @required this.contentBuilder,
    this.enablePullDown: true,
    this.enablePullUp: true,
    this.enableQuickTop: true,
    this.isNestWrapped: false,
    this.enableOverScroll: true,
    this.itemType: 0,
  }) : super(key: key);

  @override
  _RefreshLoadMoreListState createState() => _RefreshLoadMoreListState();
}

class _RefreshLoadMoreListState extends State<RefreshLoadMoreList>
    with AutomaticKeepAliveClientMixin {
  /// 数据加载类
  DataLoadMoreBase _loader;
  ScrollController scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loader = widget.dataLoader;
    super.initState();
    _loader.initScrollController(scrollController);
    _loader.obtainData(true);
  }

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // there is no method to get PrimaryScrollController in initState
    // print("PrimaryScrollController");
    if (widget.isNestWrapped) {
      scrollController = PrimaryScrollController.of(context);
      _loader.initScrollController(scrollController);
    }

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<DataLoadMoreBase>(
        stream: _loader.stream,
        builder: (context, snapshot) {
          // var loader = snapshot.data;

          /// 监听滑动结束广播
          return Scaffold(
            body: Stack(
              children: <Widget>[
                NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    if (notification.depth != 0) return false;
                    if (notification.metrics.axisDirection !=
                        AxisDirection.down) return false;

                    /// 如果没有更多, 服务返回错误信息, 网络异常,那么不允许上拉加载更多
                    if (_loader == null) return false;
                    // 加载更多
                    if (notification.metrics.maxScrollExtent -
                            notification.metrics.pixels <=
                        0) {
                      _loader.obtainData(false);
                    }
                    return false;
                  },

                  /// 下拉刷新
                  child: _loader == null
                      ? Container()
                      : widget.enablePullDown
                          ? RefreshIndicator(
                              child: SafeArea(
                              top: false,
                              bottom: false,
                              child: Builder(builder: (BuildContext context) {
                                return _contentBuilder(context, _loader);
                              })),
                              onRefresh: () => _loader.obtainData(true),
                            )
                          : SafeArea(
                              top: false,
                              bottom: false,
                              child: Builder(builder: (BuildContext context) {
                                return _contentBuilder(context, _loader);
                              })),
                ),
                new Offstage(
                  offstage: _loader == null || _loader.isInit ? false : true,
                  child: _buildWelcomeLoading(),
                ),
                new Offstage(
                  offstage: _loader.isEmpty ? false : true,
                  child: _buildEmpty(_loader),
                ),
                new Offstage(
                  offstage: _loader.isRefreshError ? false : true,
                  child: _buildRefreshError(_loader),
                ),
              ],
            ),
            floatingActionButton: buildFloatingActionButton(_loader),
          );
        });
  }

  Widget _buildEmpty(DataLoadMoreBase loader) {
    return new Material(
      child: InkWell(
        onTap: () => loader.obtainData(true, true),
        child: Center(child: Text('暂无数据')),
      ),
    );
  }

  Widget _buildRefreshError(DataLoadMoreBase loader) {
    return new Material(
      child: InkWell(
        onTap: () => loader.obtainData(true, true),
        child: Center(child: Text('加载失败，点击重试')),
      ),
    );
  }

  Widget _buildWelcomeLoading() {
    return Material(
      child: new Container(
        alignment: Alignment.center,
        child: ProgressView(),
      ),
    );
  }

  Widget buildFloatingActionButton(DataLoadMoreBase loader) {
    return widget.enableQuickTop && loader.isShowFloat ?? false
        ? FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.keyboard_arrow_up,
            ),
            onPressed: () {
              loader?.scrollTop();
            })
        : null;
  }

  ScrollView _contentBuilder(BuildContext context, DataLoadMoreBase loader) {
    ScrollView scrollView = widget.contentBuilder(context, loader);
    List<Widget> slivers =
        List.from(scrollView.buildSlivers(context), growable: true);
    if (widget.enablePullUp) {
      slivers.add(SliverToBoxAdapter(
        child: LoadMoreIndicator(dataLoader: loader),
      ));
    }
    return CustomScrollView(
      physics: RefreshScrollPhysics(enableOverScroll: widget.enableOverScroll),
      controller: scrollController,
      cacheExtent: scrollView.cacheExtent,
      key: scrollView.key,
      center: scrollView.center,
      anchor: scrollView.anchor,
      semanticChildCount: scrollView.semanticChildCount,
      slivers: slivers,
      reverse: scrollView.reverse,
    );
  }
}
