import 'package:flutter/material.dart';
import 'package:neighbours/common/component_index.dart';

import 'home/home_page.dart';
import 'shop/shop_page.dart';
import 'mine/mine_page.dart';
import 'community/community_page.dart';
import 'package:neighbours/ui/pages/home/home_drawer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  int _selectedIndex = 0; //当前选中项的索引
  static int lastExitTime = 0;
  final appBarTitles = ['首页', '商城', '社区', '我的'];
  int elevation = 4;

  var pages = <Widget>[
    HomePage(),
    ShopPage(),
    CommunityPage(),
    MinePage(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil(width: 1080,height: 1920).init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: HomeDrawer(),
        body: new IndexedStack(children: pages, index: _selectedIndex),
        //底部导航按钮 包含图标及文本
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text(appBarTitles[0])),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text(appBarTitles[1])),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), title: Text(appBarTitles[2])),
            BottomNavigationBarItem(
                icon: Icon(Icons.navigation), title: Text(appBarTitles[3])),
          ],
          type: BottomNavigationBarType.fixed, //设置显示的模式
          currentIndex: _selectedIndex, //当前选中项的索引
          onTap: _onItemTapped, //选择按下处理
        ),
      ),
    );
  }

  //选择按下处理 设置当前索引为index值
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2 || index == 4) {
        elevation = 0;
      } else {
        elevation = 4;
      }
    });
  }

  /**
   * 自定义返回键事件
   * 一定时间内点击两次退出，反之提示
   */
  Future<bool> _onBackPressed() async {
    int nowExitTime = DateTime.now().millisecondsSinceEpoch;
    if (nowExitTime - lastExitTime > 2000) {
      lastExitTime = nowExitTime;
      Utils.showToast("再按一次退出程序");
      return await Future.value(false);
    }
    return await Future.value(true);
  }
}
