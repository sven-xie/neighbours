import 'package:flutter/material.dart';
import 'package:neighbours/utils/util_index.dart';



typedef Widget SliverStickyHeaderWidgetBuilder(
    BuildContext context, SliverStickyHeaderState state);


    /// State describing how a sticky header is rendered.
@immutable
class SliverStickyHeaderState {
  const SliverStickyHeaderState(
    this.scrollPercentage,
    this.isPinned,
  )   : assert(scrollPercentage != null),
        assert(isPinned != null);

  final double scrollPercentage;

  final bool isPinned;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! SliverStickyHeaderState) return false;
    final SliverStickyHeaderState typedOther = other;
    return scrollPercentage == typedOther.scrollPercentage &&
        isPinned == typedOther.isPinned;
  }

  @override
  int get hashCode {
    return hashValues(scrollPercentage, isPinned);
  }
}

// 自定义 SliverPersistentHeaderDelegate
class CustomSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double max; // 最大高度
  final double min; // 最小高度
  final SliverStickyHeaderWidgetBuilder builder;// 需要展示的内容

  CustomSliverPersistentHeaderDelegate({@required this.max, @required this.min, @required this.builder})
      // 如果 assert 内部条件不成立，会报错
      : assert(max != null),
        assert(min != null),
        assert(builder != null),
        assert(min <= max),
        super();

  // 返回展示的内容，如果内容固定可以直接在这定义，如果需要可扩展，这边通过传入值来定义
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
       var scrollParcentage = shrinkOffset.abs()/min;
       if (scrollParcentage >= 1){
         scrollParcentage = 1;
       }else if(scrollParcentage==0){
         scrollParcentage = 1;
       }
       var state = new SliverStickyHeaderState(1-scrollParcentage,shrinkOffset>0);
        return builder(context, state);
  }

  @override
  double get maxExtent => max; // 返回最大高度

  @override
  double get minExtent => min; // 返回最小高度

  @override
  bool shouldRebuild(CustomSliverPersistentHeaderDelegate oldDelegate) {
    // 是否需要更新，这里我们定义当高度范围和展示内容被替换的时候进行刷新界面
    return max != oldDelegate.max || min != oldDelegate.min || builder != oldDelegate.builder;
  }
}