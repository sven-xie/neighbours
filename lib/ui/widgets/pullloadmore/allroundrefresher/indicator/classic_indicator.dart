import 'package:flutter/cupertino.dart';
import 'package:neighbours/ui/widgets/pullloadmore/allroundrefresher/all_round_refresher.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import '../internals/default_constants.dart';
import '../internals/indicator_wrap.dart';
import 'package:flutter/widgets.dart';

enum IconPosition { left, right, top, bottom }

class ClassicHeader extends RefreshIndicator {
  final String releaseText, idleText, refreshingText, completeText, failedText;

  final Widget releaseIcon, idleIcon, refreshingIcon, completeIcon, failedIcon;

  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  const ClassicHeader({
    Key key,
    RefreshStyle refreshStyle: default_refreshStyle,
    this.textStyle: const TextStyle(color: const Color(0xff555555)),
    double triggerDistance: default_refresh_triggerDistance,
    this.releaseText: 'Refresh when release',
    this.refreshingText: 'Refreshing...',
    this.completeText: 'Refresh complete',
    double height: default_height,
    this.failedText: 'Refresh failed',
    this.idleText: 'Pull down to refresh',
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.refreshingIcon: const SizedBox(
      width: 25.0,
      height: 25.0,
      child: const CircularProgressIndicator(strokeWidth: 2.0),
    ),
    this.failedIcon: const Icon(Icons.clear, color: Colors.grey),
    this.completeIcon: const Icon(Icons.done, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.arrow_upward, color: Colors.grey),
  }) : super(
            key: key,
            refreshStyle: refreshStyle,
            height: height,
            triggerDistance: triggerDistance);

  @override
  State createState() {
    // TODO: implement createState
    return _ClassicHeaderState();
  }
}

class _ClassicHeaderState extends RefreshIndicatorState<ClassicHeader> {
  Widget _buildText(mode) {
    return Text(
        mode == RefreshStatus.canRefresh
            ? widget.releaseText
            : mode == RefreshStatus.completed
                ? widget.completeText
                : mode == RefreshStatus.failed
                    ? widget.failedText
                    : mode == RefreshStatus.refreshing
                        ? widget.refreshingText
                        : widget.idleText,
        style: widget.textStyle);
  }

  Widget _buildIcon(mode) {
    Widget icon = mode == RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == RefreshStatus.idle
            ? widget.idleIcon
            : mode == RefreshStatus.completed
                ? widget.completeIcon
                : mode == RefreshStatus.failed
                    ? widget.failedIcon
                    : widget.refreshingIcon;
    return icon;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    // TODO: implement buildContent
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[
      iconWidget,
      Container(
        width: widget.spacing,
      ),
      textWidget
    ];
    Widget container = (widget.iconPos == IconPosition.top ||
            widget.iconPos == IconPosition.bottom)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: widget.iconPos == IconPosition.top
                ? VerticalDirection.down
                : VerticalDirection.up,
            children: children,
          )
        : Row(
            textDirection: widget.iconPos == IconPosition.right
                ? TextDirection.rtl
                : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
    return Container(
      height: widget.height,
      child: Center(
        child: container,
      ),
    );
  }
}

class ClassicFooter extends LoadIndicator {
  final String idleText, loadingText, noDataText, loadErrorText;

  final Widget idleIcon, loadingIcon, noMoreIcon, loadErrorIcon;

  final double height;

  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  const ClassicFooter({
    Key key,
    Function onClick,
    bool autoLoad: default_true,
    double triggerDistance: default_load_triggerDistance,
    this.textStyle: const TextStyle(color: const Color(0xff555555)),
    this.loadingText: '加载中',
    this.noDataText: '- END -',
    this.loadErrorText: '加载出错，点击重试',
    this.height: 60.0,
    this.noMoreIcon: const Icon(Icons.timer, color: Colors.grey),
    this.loadErrorIcon: const Icon(Icons.clear, color: Colors.grey),
    this.idleText: '等待加载中',
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.loadingIcon: const CupertinoActivityIndicator(),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
  }) : super(
            key: key,
            triggerDistance: triggerDistance,
            onClick: onClick,
            autoLoad: autoLoad);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _ClassicFooterState();
  }
}

class _ClassicFooterState extends LoadIndicatorState<ClassicFooter> {
  Widget _buildText(LoadStatus mode) {
    return Text(
        mode == LoadStatus.loading
            ? widget.loadingText
            : LoadStatus.noMore == mode
                ? widget.noDataText
                : LoadStatus.error == mode
                    ? widget.loadErrorText
                    : widget.idleText,
        style: widget.textStyle);
  }

  Widget _buildIcon(LoadStatus mode) {
    Widget icon = mode == LoadStatus.loading
        ? widget.loadingIcon
        : mode == LoadStatus.noMore
            ? widget.noMoreIcon
            : LoadStatus.error == mode ? widget.loadErrorIcon : widget.idleIcon;
    return icon;
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[];
    if (mode == LoadStatus.loading){
      children.add(iconWidget);
      children.add(Container(
        width: widget.spacing,
      ));
    }
    children.add(textWidget);
    
    Widget container = (widget.iconPos == IconPosition.top ||
            widget.iconPos == IconPosition.bottom)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: widget.iconPos == IconPosition.top
                ? VerticalDirection.down
                : VerticalDirection.up,
            children: children,
          )
        : Row(
            textDirection: widget.iconPos == IconPosition.right
                ? TextDirection.rtl
                : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        color: Colors.transparent,
        height: widget.height,
        child: Center(
          child: container,
        ),
      ),
    );
  }
}
