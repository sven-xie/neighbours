import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/res/colors.dart';
import 'package:neighbours/ui/widgets/loadmore/loading_more_base.dart';

/// 加载更多 没有数据时, 用于显示当前的状态
class LoadMoreIndicator extends StatelessWidget {
  final DataLoadMoreBase dataLoader;

  /// [dataLoader] 类型为[DataLoadMoreBase]
  const LoadMoreIndicator({Key key, this.dataLoader}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loadMore = Text("等待加载中");
    if (dataLoader != null) {
    //  print("LoadMoreIndicator dataLoader.isLoading = ${dataLoader.isLoading} ");
      loadMore = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CupertinoActivityIndicator(),
              SizedBox(width: 10.0,),
              Text("加载中",style: TextStyle(fontSize: 12,color: Colours.gray_66),)
            ],
          );

      if (dataLoader.isLoadError) {
        loadMore = Material(
          child: InkWell(
            onTap: () => dataLoader.obtainData(false,true),
            child: Center(child: Text("加载失败,点击重试",style: TextStyle(fontSize: 12,color: Colours.gray_66),)),
          ),
        );
      }

      if (dataLoader.isLoadEnd) {
        loadMore = Material(
          child:  Text("- END -",style: TextStyle(fontSize: 12,color: Colours.gray_66),)
        );
      }
    }

    return Container(
      height: 60.0,
      alignment: Alignment.center,
      child: loadMore,
    );
  }
}
