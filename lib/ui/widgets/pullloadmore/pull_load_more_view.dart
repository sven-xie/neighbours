import 'package:flutter/material.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/flutter_allroundrefresh.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/internals/default_constants.dart';

class PullLoadMoreView extends StatefulWidget {
  const PullLoadMoreView(
      {Key key,
      @required this.child,
      @required this.controller,
      this.enableOverScroll: default_true,
      this.enablePullDown: default_true,
      this.enablePullUp: default_true,
      this.enableQuickTop: default_true,
      this.isNestWrapped: false,
      this.onRefresh,
      this.onLoading,
      this.onOffsetChange,
      this.header,
      })
      : super(key: key);

  final ScrollView child;
  final bool enablePullUp;
  final bool enablePullDown;
  final bool enableQuickTop;
  final bool enableOverScroll;
  final bool isNestWrapped;
  final RefreshController controller;
  final Function onRefresh, onLoading;
  final OnOffsetChange onOffsetChange;
  final Widget header;

  @override
  State<StatefulWidget> createState() {
    return new PullLoadMoreViewState();
  }
}

class PullLoadMoreViewState extends State<PullLoadMoreView> with AutomaticKeepAliveClientMixin {
  bool isShowFloatBtn = false;

    @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AllRoundRefresher(
        enablePullDown: widget.enablePullDown,
        enablePullUp: widget.enablePullUp,
        header: widget.header ?? WaterDropHeader(),
        controller: widget.controller,
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        onOffsetChange: widget.onOffsetChange,
        child: widget.child,
        isNestWrapped: widget.isNestWrapped,
      );
  }
}
