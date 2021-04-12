import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 仿朋友圈九宫格布局
class XFlow extends StatelessWidget {
  final List<Widget> children;
  /// 子view总数
  final int count;
  /// 间距
  final double gap;
  final double magin;
  
  XFlow({
    Key key, 
    this.children,
    this.magin,
    @required this.count,
    this.gap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: CLFlowDelegate(
        count: count,
        ),
        children: children,
    );
  }
}

class CLFlowDelegate extends FlowDelegate {
  final int count;
  final double gap;
  final double magin;
  CLFlowDelegate({
     @required this.count,
     this.gap = 8.0,
     this.magin = 8.0,
     });

  var columns = 3;
  var rows = 3;
  double itemW = 0;
  double itemH = 0;
  double totalW = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = gap;
    var y = 0.0;

    /// 需要重新计算,解决刷新值为0的问题
    // totalW = ScreenUtil.getInstance().width - magin*2;
    getColumnsNumber(count);
    getItemSize();
    totalW = (itemW * rows) + (gap * (rows + 1));

    //计算每一个子widget的位置  
    for (int i = 0; i < count; i++) {
      var w = context.getChildSize(i).width + x;
      if (w < totalW) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                x, y, 0.0));
        x += context.getChildSize(i).width + gap;
      } else {
        x = gap;
        y += context.getChildSize(i).height + gap;
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                x, y, 0.0));
         x += context.getChildSize(i).width + gap;
      }
    }
  }
  
  getColumnsNumber(int length) {
    if (length <= 3) {
        rows = length;
        columns = 1;
    } else if (length <= 6) {
        rows = 3;
        columns = 2;
        if (length == 4) {
            rows = 2;
        }
    } else {
        rows = 3;
        columns = 3;
    }
  }

  getItemSize() {
     if (rows == 1) {
      itemW = totalW/2;
      itemH = totalW/2;
    }else if (rows == 2){
      itemW = (totalW - gap)/2;
      itemH = (totalW - gap)/2;
    }else if (rows == 3) {
      itemW = (totalW - gap*2)/3;
      itemH = (totalW - gap*2)/3;
    } 
  }

  /// 设置每个子view的size
  getConstraintsForChild(int i, BoxConstraints constraints) {
    getItemSize();
    return BoxConstraints(
      minWidth: itemW,
      minHeight: itemH,
      maxWidth: itemW,
      maxHeight: itemH
    );

  }

  /// 设置flow的size
  getSize(BoxConstraints constraints){ 
    getColumnsNumber(count);
    getItemSize();
    double h = (columns * itemH) + ((columns - 1) * gap);
    // totalW = ScreenUtil.getInstance().width - magin*2;
     totalW = (itemW * rows) + (gap * (rows + 1));

    return Size(totalW, h);
  }
  
  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}