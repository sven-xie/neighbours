import 'package:flutter/material.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/utils/util_index.dart';


class GoodItem extends StatelessWidget {
  const GoodItem(this.index);
  final int index;

  Widget _widget_tag(@required String text,String tagType) {

    Color bgcolor=Colors.green[100];
    Color tcolor=Colors.green[500];

    switch(tagType){
      case "allnew":
         bgcolor=Colors.red[100];
         tcolor=Colors.red[500];
        break;
        default:

    }
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 0),
      margin: EdgeInsets.only(left: 4),
      child: Text(text, style: new TextStyle(fontSize:10,color: tcolor)),
      decoration:  new BoxDecoration(
        color:bgcolor,
        borderRadius: BorderRadius.circular(2)),
    );
  }
  Widget _widget_tags(){
    return new Row(
      children: <Widget>[
        _widget_tag("新品上市",""),
        _widget_tag("限时","allnew"),
      ],
    );
  }


  Widget _widget_item_card(){
    return new Card(
      child: new Column(
        children: <Widget>[
          new Hero(
              tag:'list-info${index}',
              child: Img('https://picsum.photos/350/500?image=${index}'),
          ),
          new Padding(
            padding: const EdgeInsets.all(8),
            child: new Column(
              children: <Widget>[
                new Text(
                    "${index}-HP/惠普810G2",
                    maxLines: index%3+1, // 元固定数据为2行 index%3+1 是为了做瀑布流高低错落效果
                    style: new TextStyle(color: Colours.text_dark,fontWeight: FontWeight.bold, fontSize: 12) ),

                new Text(
                    "旋转变形触控笔记本电脑 手提学生商务游戏本,最新优惠打折扣，速速抢购",
                    maxLines: index%3+1, // 元固定数据为2行 index%3+1 是为了做瀑布流高低错落效果
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(color: Colours.text_gray, fontWeight: FontWeight.normal, fontSize: 12) ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //子组件在主轴的排列方式为两端对齐
                  children: <Widget>[
                    new Text("￥88${index}", style: new TextStyle( color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                    _widget_tags(),
                  ],
                ),
                new Divider(
                  color: Colors.grey,
                ), //分割线控件
                new Row(
                  children: <Widget>[
                    Img("https://picsum.photos/128/128?image=${index}",radius:14,isCircle: true,),
                    new Padding(
                        padding: new EdgeInsets.only(left: 8),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("我是昵称",maxLines: 1, overflow: TextOverflow.ellipsis,style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12)),
                            new Text("实体认证 | 信用极好",maxLines: 1, overflow: TextOverflow.ellipsis,style: new TextStyle(color: Colors.green,fontSize: 10)),
                          ],
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        child: _widget_item_card(),
        onTap:() {
          // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          //   return new GoodInfo(index: this.index.toString());
          // }));
          Utils.showToast("查看商品详情");
        }
    );

  }
}