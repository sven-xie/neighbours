import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neighbours/res/res_index.dart';

/// return true is refresh success
///
/// return false or null is fail
typedef Future<bool> FutureCallBack();

class LoadMore_1 extends StatefulWidget {
  static DelegateBuilder<LoadMoreDelegate> buildDelegate =
      () => DefaultLoadMoreDelegate();
  static DelegateBuilder<LoadMoreTextBuilder> buildTextBuilder =
      () => DefaultLoadMoreTextBuilder.chinese;

  final ScrollView child;

  /// return true is refresh success
  ///
  /// return false or null is fail
  final FutureCallBack onLoadMore;

  /// if [isFinish] is true, then loadMoreWidget status is [LoadMoreStatus.nomore].
  final bool isFinish;

  /// see [LoadMoreDelegate]
  final LoadMoreDelegate delegate;

  /// see [LoadMoreTextBuilder]
  final LoadMoreTextBuilder textBuilder;

  /// when [whenEmptyLoad] is true, and when listView children length is 0,or the itemCount is 0,not build loadMoreWidget
  final bool whenEmptyLoad;

  const LoadMore_1({
    Key key,
    @required this.child,
    @required this.onLoadMore,
    this.textBuilder,
    this.isFinish = false,
    this.delegate,
    this.whenEmptyLoad = true,
  }) : super(key: key);

  @override
  _LoadMoreState createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore_1> {
  Widget get child => widget.child;

  LoadMoreDelegate get loadMoreDelegate =>
      widget.delegate ?? LoadMore_1.buildDelegate();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slivers =
        List.from(widget.child.buildSlivers(context), growable: true);
     slivers.add(_buildLoadMoreView());
    return new SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener<ScrollEndNotification>(
              // or  OverscrollNotification
              onNotification: (ScrollEndNotification scroll) {
                if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                  // Scroll End
                  print("??????????????????????????????");
                  _loadMoreEvent();
                }
              },
              child: CustomScrollView(
                slivers: slivers,
              ));
        },
      ),
    );
  }

  /// if call the method, then the future is not null
  /// so, return a listview and  item count + 1
  // Widget _buildListView(ListView listView) {
  //   var delegate = listView.childrenDelegate;
  //   outer:
  //   if (delegate is SliverChildBuilderDelegate) {
  //     SliverChildBuilderDelegate delegate = listView.childrenDelegate;
  //     if (!widget.whenEmptyLoad && delegate.estimatedChildCount == 0) {
  //       break outer;
  //     }
  //     var viewCount = delegate.estimatedChildCount + 1;
  //     IndexedWidgetBuilder builder = (context, index) {
  //       if (index == viewCount - 1) {
  //         return _buildLoadMoreView();
  //       }
  //       return delegate.builder(context, index);
  //     };

  //     return ListView.builder(
  //       itemBuilder: builder,
  //       addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
  //       addRepaintBoundaries: delegate.addRepaintBoundaries,
  //       itemCount: viewCount,
  //       cacheExtent: listView.cacheExtent,
  //       controller: listView.controller,
  //       itemExtent: listView.itemExtent,
  //       key: listView.key,
  //       padding: listView.padding,
  //       physics: listView.physics,
  //       primary: listView.primary,
  //       reverse: listView.reverse,
  //       scrollDirection: listView.scrollDirection,
  //       shrinkWrap: listView.shrinkWrap,
  //     );
  //   } else if (delegate is SliverChildListDelegate) {
  //     SliverChildListDelegate delegate = listView.childrenDelegate;

  //     if (!widget.whenEmptyLoad && delegate.estimatedChildCount == 0) {
  //       break outer;
  //     }

  //     delegate.children.add(_buildLoadMoreView());
  //     return ListView(
  //       children: delegate.children,
  //       addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
  //       addRepaintBoundaries: delegate.addRepaintBoundaries,
  //       cacheExtent: listView.cacheExtent,
  //       controller: listView.controller,
  //       itemExtent: listView.itemExtent,
  //       key: listView.key,
  //       padding: listView.padding,
  //       physics: listView.physics,
  //       primary: listView.primary,
  //       reverse: listView.reverse,
  //       scrollDirection: listView.scrollDirection,
  //       shrinkWrap: listView.shrinkWrap,
  //     );
  //   }
  //   return listView;
  // }

  LoadMoreStatus status = LoadMoreStatus.idle;

  Widget _buildLoadMoreView() {
    return NotificationListener<_RetryNotify>(
      child: NotificationListener<_BuildNotify>(
        child: DefaultLoadMoreView(
          status: status,
          delegate: loadMoreDelegate,
          textBuilder: widget.textBuilder ?? LoadMore_1.buildTextBuilder(),
        ),
        onNotification: _onLoadMoreBuild,
      ),
      onNotification: _onRetry,
    );
  }

  void _loadMoreEvent() async {
    if (widget.isFinish == true) {
      this.status = LoadMoreStatus.nomore;
    } else {
      if (this.status == LoadMoreStatus.nomore) {
        this.status = LoadMoreStatus.idle;
      }
    }
    // var delay =
    //     max(loadMoreDelegate.loadMoreDelay(), Duration(milliseconds: 16));
    // await Future.delayed(delay);
    if (this.status == LoadMoreStatus.idle) {
      print("_loadMoreEvent");
      //????????????????????????????????????
      if (status == LoadMoreStatus.loading) {}
      if (status == LoadMoreStatus.nomore) {}
      if (status == LoadMoreStatus.fail) {}
      if (status == LoadMoreStatus.idle) {
        // ?????????????????????????????????????????????
        print("loadMore=======");
        loadMore();
      }
    }
  }

  Duration max(Duration duration, Duration duration2) {
    if (duration > duration2) {
      return duration;
    }
    return duration2;
  }

  bool _onLoadMoreBuild(_BuildNotify notification) {
    print("_onLoadMoreBuild");
    //????????????????????????????????????
    if (status == LoadMoreStatus.loading) {
      return false;
    }
    if (status == LoadMoreStatus.nomore) {
      return false;
    }
    if (status == LoadMoreStatus.fail) {
      return false;
    }
    if (status == LoadMoreStatus.idle) {
      // ?????????????????????????????????????????????
      print("loadMore=======");
      loadMore();
    }
    return false;
  }

  void _updateStatus(LoadMoreStatus status) {
    if (mounted) {
      print("updata_status == $status");
      setState(() => this.status = status);
    }
  }

  bool _onRetry(_RetryNotify notification) {
    loadMore();
    return false;
  }

  void loadMore() {
    _updateStatus(LoadMoreStatus.loading);
    widget.onLoadMore().then((v) {
      if (v == true) {
        // ??????????????????????????????
        _updateStatus(LoadMoreStatus.idle);
      } else {
        // ??????????????????????????????
        _updateStatus(LoadMoreStatus.fail);
      }
    });
  }
}

enum LoadMoreStatus {
  /// ????????????????????????????????????
  ///
  /// wait for loading
  idle,

  /// ??????????????????????????????????????????future??????
  ///
  /// the view is loading
  loading,

  /// ????????????????????????????????????????????????????????????
  ///
  /// loading fail, need tap view to loading
  fail,

  /// ????????????????????????????????????????????????????????????????????????
  ///
  /// not have more data
  nomore,
}

class DefaultLoadMoreView extends StatefulWidget {
  final LoadMoreStatus status;
  final LoadMoreDelegate delegate;
  final LoadMoreTextBuilder textBuilder;
  const DefaultLoadMoreView({
    Key key,
    this.status = LoadMoreStatus.idle,
    @required this.delegate,
    @required this.textBuilder,
  }) : super(key: key);

  @override
  DefaultLoadMoreViewState createState() => DefaultLoadMoreViewState();
}

const _defaultLoadMoreHeight = 80.0;
const _loadmoreIndicatorSize = 20.0;
const _loadMoreDelay = 16;

class DefaultLoadMoreViewState extends State<DefaultLoadMoreView> {
  LoadMoreDelegate get delegate => widget.delegate;

  @override
  Widget build(BuildContext context) {
    print("build == ${widget.status}");
     notify();
    return new SliverToBoxAdapter(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (widget.status == LoadMoreStatus.fail) {
            _RetryNotify().dispatch(context);
          }
        },
        child: Container(
          height: delegate.widgetHeight(widget.status),
          alignment: Alignment.center,
          child: delegate.buildChild(
            widget.status,
            builder: widget.textBuilder,
          ),
        ),
      ),
    );
  }

  void notify() async {
    var delay = max(delegate.loadMoreDelay(), Duration(milliseconds: 16));
    await Future.delayed(delay);
    if (widget.status == LoadMoreStatus.idle) {
      _BuildNotify().dispatch(context);
    }
  }

  Duration max(Duration duration, Duration duration2) {
    if (duration > duration2) {
      return duration;
    }
    return duration2;
  }
}

class _BuildNotify extends Notification {}

class _RetryNotify extends Notification {}

typedef T DelegateBuilder<T>();

/// loadmore widget properties
abstract class LoadMoreDelegate {
  static DelegateBuilder<LoadMoreDelegate> buildWidget =
      () => DefaultLoadMoreDelegate();

  const LoadMoreDelegate();

  /// the loadmore widget height
  double widgetHeight(LoadMoreStatus status) => _defaultLoadMoreHeight;

  /// build loadmore delay
  Duration loadMoreDelay() => Duration(milliseconds: _loadMoreDelay);

  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese});
}

class DefaultLoadMoreDelegate extends LoadMoreDelegate {
  const DefaultLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese}) {
    print("buildChild == $status");
    String text = builder(status);
    List<Widget> list = new List();
    if (status == LoadMoreStatus.fail) {
      list.add(Text(text));
    }
    else if (status == LoadMoreStatus.idle) {
      list.add(Text(text));
    }
    else if (status == LoadMoreStatus.loading) {
      print("buildChild == loading");
      list.add(Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: _loadmoreIndicatorSize,
              height: _loadmoreIndicatorSize,
              child: CircularProgressIndicator(
                backgroundColor: Colours.app_main,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              ),
            ),
          ],
        ),
      ));
    }
    else if (status == LoadMoreStatus.nomore) {
      list.add(Text(text));
    }

    return new Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(bottom: 10),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: list,
        ));
  }
}

typedef String LoadMoreTextBuilder(LoadMoreStatus status);

String _buildChineseText(LoadMoreStatus status) {
  String text;
  switch (status) {
    case LoadMoreStatus.fail:
      text = "??????????????????????????????";
      break;
    case LoadMoreStatus.idle:
      text = "??????????????????";
      break;
    case LoadMoreStatus.loading:
      text = "?????????????????????...";
      break;
    case LoadMoreStatus.nomore:
      text = "?????????????????????";
      break;
    default:
      text = "";
  }
  return text;
}

String _buildEnglishText(LoadMoreStatus status) {
  String text;
  switch (status) {
    case LoadMoreStatus.fail:
      text = "load fail, tap to retry";
      break;
    case LoadMoreStatus.idle:
      text = "wait for loading";
      break;
    case LoadMoreStatus.loading:
      text = "loading, wait for moment ...";
      break;
    case LoadMoreStatus.nomore:
      text = "no more data";
      break;
    default:
      text = "";
  }
  return text;
}

class DefaultLoadMoreTextBuilder {
  static const LoadMoreTextBuilder chinese = _buildChineseText;

  static const LoadMoreTextBuilder english = _buildEnglishText;
}
