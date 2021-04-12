import 'package:flutter/material.dart';
import 'dart:async';  //Timer

class YYMarquee extends StatefulWidget {
  Widget child;  // 轮播的内容
  Duration duration;  // 轮播时间
  double stepOffset;  // 偏移量
  double paddingLeft;  // 内容之间的间距

  YYMarquee(this.child, this.paddingLeft, this.duration, this.stepOffset);

  _YYMarqueeState createState() => _YYMarqueeState();
}


class _YYMarqueeState extends State<YYMarquee> {
  ScrollController _controller;  // 执行动画的controller
  Timer _timer;  // 定时器timer
  double _offset = 0.0;  // 执行动画的偏移量

  @override
  void initState() {
    super.initState();

    _controller = ScrollController(initialScrollOffset: _offset);
    _timer = Timer.periodic(widget.duration, (timer) {
      double newOffset = _controller.offset + widget.stepOffset;
      if (newOffset != _offset) {
        _offset = newOffset;
        _controller.animateTo(
            _offset,
            duration: widget.duration, curve: Curves.linear);  // 线性曲线动画 
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _child() {
    return new Row(
        children: _children()
    );
  }

  // 子视图
  List<Widget> _children() {
    List<Widget> items = [];
    for (var i = 0; i<=2; i++) {
      Container item = new Container(
        margin: new EdgeInsets.only(right: i != 0 ? 0.0 : widget.paddingLeft),
        child: i != 0 ? null : widget.child,
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,  // 横向滚动
      controller: _controller,  // 滚动的controller
      itemBuilder: (context, index) {
        return _child();
      },
    );
  }
}
 
//公告栏动画 垂直淡入淡出
class MyNoticeVecAnimation extends StatefulWidget {
  final Duration duration;
  final List<String> messages;
 
  const MyNoticeVecAnimation({
    Key key,
    this.duration = const Duration(milliseconds: 3000),
    this.messages,
  }) : super(key: key);
 
  @override
  _MyNoticeVecAnimationState createState() {
    // TODO: implement createState
    return _MyNoticeVecAnimationState();
  }
}
 
class _MyNoticeVecAnimationState extends State<MyNoticeVecAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
 
  int _nextMassage = 0;
 
  //透明度
  Animation<double> _opacityAni1, _opacityAni2;
 
  //位移
  Animation<Offset> _positionAni1, _positionAni2;
 
  @override
  Widget build(BuildContext context) {
    _startVerticalAni();
    //正向开启动画
    // TODO: implement build
    return SlideTransition(
      position: _positionAni2,
      child: FadeTransition(
        opacity: _opacityAni2,
        child: SlideTransition(
          position: _positionAni1,
          child: FadeTransition(
            opacity: _opacityAni1,
            child: Text(
              widget.messages[_nextMassage],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }
 
 
  //纵向滚动
  void _startVerticalAni() {
    // TODO: implement initState
    _controller = AnimationController(duration: widget.duration, vsync: this);
 
    _opacityAni1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.0, 0.1, curve: Curves.linear)),
    );
 
    _opacityAni2 = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.9, 1.0, curve: Curves.linear)),
    );
 
    _positionAni1 = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.0, 0.1, curve: Curves.linear)),
    );
 
    _positionAni2 = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -1.0),
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.9, 1.0, curve: Curves.linear)),
    );
 
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _nextMassage++;
            if (_nextMassage >= widget.messages.length) {
              _nextMassage = 0;
            }
          });
          _controller.reset();
          _controller.forward();
        }
        if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }
 
  //释放
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}




//公告栏动画 水平淡入淡出
class MyNoticeHorAnimation extends StatefulWidget {
  final Duration duration;
  final List<String> messages;
 
  const MyNoticeHorAnimation({
    Key key,
    this.duration = const Duration(milliseconds: 3000),
    this.messages,
  }) : super(key: key);
 
  @override
  _MyNoticeHorAnimationState createState() {
    // TODO: implement createState
    return _MyNoticeHorAnimationState();
  }
}
 
class _MyNoticeHorAnimationState extends State<MyNoticeHorAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
 
  int _nextMassage = 0;
 
  //透明度
  Animation<double> _opacityAni1, _opacityAni2;
 
  //位移
  Animation<Offset> _positionAni1, _positionAni2;
 
  @override
  Widget build(BuildContext context) {
    _startHorizontalAni();
    //正向开启动画
    // TODO: implement build
    return SlideTransition(
      position: _positionAni2,
      child: FadeTransition(
        opacity: _opacityAni2,
        child: SlideTransition(
          position: _positionAni1,
          child: FadeTransition(
            opacity: _opacityAni1,
            child: Text(
              widget.messages[_nextMassage],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }
 
  //横向滚动
  void _startHorizontalAni() {
    // TODO: implement initState
    _controller = AnimationController(duration: widget.duration, vsync: this);
 
    _opacityAni1 = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear)),
    );
 
    _opacityAni2 = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.0, 0.0, curve: Curves.linear)),
    );
 
    _positionAni1 = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.linear)),
    );
 
    _positionAni2 = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.linear)),
    );
 
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _nextMassage++;
            if (_nextMassage >= widget.messages.length) {
              _nextMassage = 0;
            }
          });
          _controller.reset();
          _controller.forward();
        }
        if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }
 
  //释放
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
