import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neighbours/res/colors.dart';

typedef OnFooterClick = Future<void> Function();

class MyFooter extends Footer {
  /// Key
  final Key key;

  /// 颜色
  final Color color;

  /// 背景颜色
  final Color backgroundColor;

  final LinkFooterNotifier linkNotifier = LinkFooterNotifier();

  MyFooter({
    this.key,
    this.color = Colors.blue,
    this.backgroundColor,
    bool enableHapticFeedback = true,
    bool enableInfiniteLoad = true,
  }) : super(
          extent: 70.0,
          triggerDistance: 70.0,
          float: false,
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteLoad: enableInfiniteLoad,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    // 不能为水平方向
    assert(
        axisDirection == AxisDirection.down ||
            axisDirection == AxisDirection.up,
        'Widget cannot be horizontal');
    linkNotifier.contentBuilder(
        context,
        loadState,
        pulledExtent,
        loadTriggerPullDistance,
        loadIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteLoad,
        success,
        noMore);
    return MyFooterWidget(
      key: key,
      color: color,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}

class MyFooterWidget extends StatefulWidget {
  /// 颜色
  final Color color;

  /// 背景颜色
  final Color backgroundColor;

  final LinkFooterNotifier linkNotifier;

  const MyFooterWidget({
    Key key,
    this.color,
    this.backgroundColor,
    this.linkNotifier,
  }) : super(key: key);

  @override
  _MyFooterWidgetState createState() => _MyFooterWidgetState();
}

class _MyFooterWidgetState extends State<MyFooterWidget> {
  LoadMode get _refreshState => widget.linkNotifier.loadState;
  double get _indicatorExtent => widget.linkNotifier.loadIndicatorExtent;
  bool get _noMore => widget.linkNotifier.noMore;
  bool get _loadSuccess => widget.linkNotifier.success;

  @override
  Widget build(BuildContext context) {
    print("_refreshState == $_refreshState" +
        ";_noMore== $_noMore" +
        ";_loadSuccess== $_loadSuccess");
    Widget loadMore = Text("等待加载中");
    if (_refreshState != null) {
      //  print("LoadMoreIndicator dataLoader.isLoading = ${dataLoader.isLoading} ");
      loadMore = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CupertinoActivityIndicator(),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "加载中",
            style: TextStyle(fontSize: 12, color: Colours.gray_66),
          )
        ],
      );

      if (!_loadSuccess) {
        loadMore = Material(
          child: Center(
              child: Text(
            "加载失败,点击重试",
            style: TextStyle(fontSize: 12, color: Colours.gray_66),
          )),
        );
      }

      if (_noMore) {
        loadMore = Material(
            child: Text(
          "- END -",
          style: TextStyle(fontSize: 12, color: Colours.gray_66),
        ));
      }
    }

    return GestureDetector(
      onTap: () {
        print("点击了失败重试");
        if (!_loadSuccess) {
          print("点击了失败重试");
        }
      },
      child: Container(
        height: 60.0,
        alignment: Alignment.center,
        child: loadMore,
      ),
      behavior: HitTestBehavior.translucent,
    );
  }
}









// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// 质感设计Header
class MyHeader extends Header {
  final Key key;
  final double displacement;

  /// 颜色
  final Animation<Color> valueColor;

  /// 背景颜色
  final Color backgroundColor;

  final LinkHeaderNotifier linkNotifier;

  MyHeader({
    this.key,
    @required this.linkNotifier,
    this.displacement = 40.0,
    this.valueColor,
    this.backgroundColor,
    completeDuration = const Duration(seconds: 1),
    bool enableHapticFeedback = false,
  }) : super(
          float: true,
          extent: 70.0,
          triggerDistance: 70.0,
          completeDuration: completeDuration == null
              ? Duration(
                  milliseconds: 300,
                )
              : completeDuration +
                  Duration(
                    milliseconds: 300,
                  ),
          enableInfiniteRefresh: false,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return MaterialHeaderWidget(
      key: key,
      displacement: displacement,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}

/// 质感设计Header组件
class MaterialHeaderWidget extends StatefulWidget {
  final double displacement;
  // 颜色
  final Animation<Color> valueColor;
  // 背景颜色
  final Color backgroundColor;
  final LinkHeaderNotifier linkNotifier;

  const MaterialHeaderWidget({
    Key key,
    this.displacement,
    this.valueColor,
    this.backgroundColor,
    this.linkNotifier,
  }) : super(key: key);

  @override
  MaterialHeaderWidgetState createState() {
    return MaterialHeaderWidgetState();
  }
}

class MaterialHeaderWidgetState extends State<MaterialHeaderWidget>
    with TickerProviderStateMixin<MaterialHeaderWidget> {
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1.0, end: 0.0);

  RefreshMode get _refreshState => widget.linkNotifier.refreshState;
  double get _pulledExtent => widget.linkNotifier.pulledExtent;
  double get _riggerPullDistance =>
      widget.linkNotifier.refreshTriggerPullDistance;
  Duration get _completeDuration => widget.linkNotifier.completeDuration;
  AxisDirection get _axisDirection => widget.linkNotifier.axisDirection;
  bool get _noMore => widget.linkNotifier.noMore;

  // 动画
  AnimationController _scaleController;
  Animation<double> _scaleFactor;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @override
  void dispose() {
    super.dispose();
    _scaleController.dispose();
  }

  // 是否刷新完成
  bool _refreshFinish = false;
  set refreshFinish(bool finish) {
    if (_refreshFinish != finish) {
      if (finish) {
        Future.delayed(_completeDuration - Duration(milliseconds: 300), () {
          if (mounted) {
            _scaleController.animateTo(1.0, duration: _kIndicatorScaleDuration);
          }
        });
        Future.delayed(_completeDuration, () {
          _refreshFinish = false;
          _scaleController.animateTo(0.0, duration: Duration(milliseconds: 10));
        });
      }
      _refreshFinish = finish;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_noMore) return Container();
    // 是否为垂直方向
    bool isVertical = _axisDirection == AxisDirection.down ||
        _axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = _axisDirection == AxisDirection.up ||
        _axisDirection == AxisDirection.left;
    // 计算进度值
    double indicatorValue = _pulledExtent / _riggerPullDistance;
    indicatorValue = indicatorValue < 1.0 ? indicatorValue : 1.0;
    // 判断是否刷新结束
    if (_refreshState == RefreshMode.refreshed) {
      refreshFinish = true;
    }
    return Container(
      height: isVertical
          ? _refreshState == RefreshMode.inactive ? 0.0 : _pulledExtent
          : double.infinity,
      width: !isVertical
          ? _refreshState == RefreshMode.inactive ? 0.0 : _pulledExtent
          : double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: isVertical ? isReverse ? 0.0 : null : 0.0,
            bottom: isVertical ? !isReverse ? 0.0 : null : 0.0,
            left: !isVertical ? isReverse ? 0.0 : null : 0.0,
            right: !isVertical ? !isReverse ? 0.0 : null : 0.0,
            child: Container(
              padding: EdgeInsets.only(
                top: isVertical ? isReverse ? 0.0 : widget.displacement : 0.0,
                bottom:
                    isVertical ? !isReverse ? 0.0 : widget.displacement : 0.0,
                left: !isVertical ? isReverse ? 0.0 : widget.displacement : 0.0,
                right:
                    !isVertical ? !isReverse ? 0.0 : widget.displacement : 0.0,
              ),
              alignment: isVertical
                  ? isReverse ? Alignment.topCenter : Alignment.bottomCenter
                  : isReverse ? Alignment.centerLeft : Alignment.centerRight,
              child: ScaleTransition(
                scale: _scaleFactor,
                child: RefreshProgressIndicator(
                  value: _refreshState == RefreshMode.armed ||
                          _refreshState == RefreshMode.refresh ||
                          _refreshState == RefreshMode.refreshed ||
                          _refreshState == RefreshMode.done
                      ? null
                      : indicatorValue,
                  valueColor: widget.valueColor,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
