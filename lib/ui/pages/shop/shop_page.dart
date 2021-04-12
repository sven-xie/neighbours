import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:ui';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/ui/pages/search/search_page.dart';
import 'package:neighbours/ui/pages/shop/shop_recommend.dart';
import 'package:neighbours/ui/pages/shop/shop_type_tissue.dart';
import 'package:neighbours/utils/util_index.dart';

import 'good_item.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  List<int> list = [];
  int tabIndex = 0;
  var _tabs = ["推荐", "纸巾", "纸巾", "纸巾", "纸巾"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              title: new Text("商城"),
              elevation: 3,
              forceElevated: innerBoxIsScrolled,
              leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: SearchBarDelegate());
                    })
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 45.0),
                child: Container(
                  height: 45.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TabBar(
                          indicatorColor: Colors.white,
                          labelStyle: TextStyle(fontSize: 16),
                          unselectedLabelStyle: TextStyle(fontSize: 16),
                          isScrollable: true,
                          tabs: _tabs
                              .map((String name) => Tab(text: name))
                              .toList(),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Utils.showToast("查看更多种类");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("更多",
                              style: TextStyle(
                                  fontSize: 16, color: Colours.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  if (name == "推荐") {
                    return ShopRecommend();
                  }
                  return ShopTypeTissue();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
