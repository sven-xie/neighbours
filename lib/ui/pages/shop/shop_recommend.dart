import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:neighbours/models/Model.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/ui/pages/home/home_section.dart';
import 'package:neighbours/ui/pages/shop/good_item.dart';
import 'package:neighbours/ui/widgets/loadmore/x_refresh_load_more.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:neighbours/utils/utils.dart';
import 'package:neighbours/models/comments.dart';

class ShopRecommend extends StatefulWidget {
  const ShopRecommend();
  @override
  _ShopRecommendState createState() => _ShopRecommendState();
}

class _ShopRecommendState extends State<ShopRecommend>
    with AutomaticKeepAliveClientMixin {
  int get count => list.length;
  List<Comment> list = [];
  List<String> _bannerList = [
    "https://th.bing.com/th/id/OIP.5YRSsEk6V7a4k8ewFSCGAAHaEo?pid=ImgDet&rs=1",
    "https://th.bing.com/th/id/OIP.5YRSsEk6V7a4k8ewFSCGAAHaEo?pid=ImgDet&rs=1",
    "https://th.bing.com/th/id/OIP.5YRSsEk6V7a4k8ewFSCGAAHaEo?pid=ImgDet&rs=1",
    "https://th.bing.com/th/id/OIP.5YRSsEk6V7a4k8ewFSCGAAHaEo?pid=ImgDet&rs=1",
    "https://th.bing.com/th/id/OIP.5YRSsEk6V7a4k8ewFSCGAAHaEo?pid=ImgDet&rs=1",
  ];
  DataLoadMoreBase _dataLoader;

  @override
  void initState() {
    _dataLoader = _DataLoader(0);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return RefreshLoadMoreList(
      dataLoader: _dataLoader,
      contentBuilder: _contentBuilder,
      // isNestWrapped: true,
    );
  }

  ScrollView _contentBuilder(
      BuildContext context, DataLoadMoreBase dataLoader) {
    var itemCount = dataLoader.length;
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              Container(
                  color: Colours.white,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: ScreenUtil.getInstance().setHeight(450.0),
                  child: RefreshSafeArea(
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return CacheImgRadius(
                            imgUrl: _bannerList[index], radius: 0);
                      },
                      pagination: new SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                        color: Colours.transparent_80,
                        activeColor: Colours.white,
                        activeSize: 6.0,
                        size: 6.0,
                      )),
                      scrollDirection: Axis.horizontal,
                      itemCount: _bannerList.length,
                      viewportFraction: 1,
                      scale: 1,
                      autoplay: true,
                    ),
                  )),
              HomeSectionView(
                  "????????????",
                  () => Scaffold.of(context).showSnackBar(new SnackBar(
                          content: CText(
                        "????????????",
                        textSize: 14,
                        bold: true,
                      )))),
              Container(
                color: Colours.white,
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 8) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("????????????"),
                        ),
                      );
                    }
                    return _buildDiscountListItem(context);
                  },
                  itemCount: 9,
                ),
              ),
              Container(
                width: double.infinity,
                height: 10.0,
                color: Colours.app_bg,
              ),
            ],
          ),
        ),
        SliverStaggeredGrid.countBuilder(
          itemCount: itemCount,
          crossAxisCount: 4,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          itemBuilder: (context, index) => new GoodItem(index),
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        ),
      ],
    );
  }

  Widget _buildDiscountListItem(BuildContext context) {
    return Container(
      color: Colours.white,
      width: 100,
      padding: EdgeInsetsDirectional.only(
        start: 10,
      ),
      child: InkWell(
        onTap: () {
          Utils.showToast("??????????????????");
        },
        child: Column(
          children: <Widget>[
            Img(
              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558154521562&di=dfcb936387c90a14c68879dcd2dea860&imgtype=0&src=http%3A%2F%2Fwww.hechengbangong.com%2Fannex%2Fcommon%2Fproduct%2F100425%2F20180121040238753-max.jpg",
              radius: 2,
              width: 100,
              height: 90,
            ),
            Padding(padding: EdgeInsets.only(top: 2)),
            Container(
              width: 80,
              child: Text(
                "????????????????????????????????????????????????????????????????????????",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.listExtra,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ????????????????????????
class _DataLoader extends DataLoadMoreBase<Comment, Model> {
  int _id; // ??????????????????

  _DataLoader(this._id);

  @override
  Future<Model> getRequest(
      bool isRefresh, int currentPage, int pageSize) async {
    await Future.delayed(Duration(seconds: 1));

    if (currentPage == 1 && Random().nextBool()) {
      return Model(data: List(), message: "????????????", code: 0);
    }

    if (Random().nextBool()) {
      return Model(data: null, message: "????????????", code: 1);
    }

    if (currentPage == 4) {
      return Model(
          data: new List.of(articleList.sublist(0, 2)),
          message: "????????????",
          code: 0);
    }

    return Model(data: new List.of(articleList), message: "????????????", code: 0);
  }

  @override
  Future<bool> handlerData(Model model, bool isRefresh) async {
    // 1. ???????????????????????????,
    // 2. ?????????????????????, ???????????????????????????
    // 3. ???????????????????????????
    if (model == null || model.isError()) {
      return false;
    }

    if (isRefresh) clear();

    // todo ?????????????????????????????????
    addAll((model.data as List<dynamic>).map((d) {
      return d as Comment;
    }));

    return true;
  }

  @override
  bool hasMore() => !isLoadEnd;
}
