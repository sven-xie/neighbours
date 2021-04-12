import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/common/component_index.dart';

class BoxWithBottomComment extends StatelessWidget {
  const BoxWithBottomComment({this.child, this.commentStr});

  final Widget child;
  final String commentStr;

  @override
  Widget build(BuildContext context) {
    //hide bottom player controller when view inserts
    //bottom too height (such as typing with soft keyboard)
    ///fixme [Scaffold#resizeToAvoidBottomInset] 影响了这个判断
    bool hide = isSoftKeyboardDisplay(MediaQuery.of(context));
    return Column(
      children: <Widget>[
        Expanded(child: child),
        hide ? Container() : CommentBar(commentStr),
      ],
    );
  }
}

class CommentBar extends StatelessWidget {
  CommentBar(this.commentStr);
  final String commentStr;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(4.0),
              topRight: const Radius.circular(4.0))),
      child: Container(
        height: ScreenUtil.instance.setHeight(120),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10.0,),
            Hero(
              tag: "user_head_image",
              child: ExtendedImage.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559274705846&di=7cc71bfccce544516ebc8bb9a9051428&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F75%2F45%2F28300001051406139579455890736_950.jpg",
                width: ScreenUtil.instance.setWidth(100),
                height: ScreenUtil.instance.setWidth(100),
                fit: BoxFit.fill,
                cache: true,
                border: Border.all(color: Colors.grey, width: 0.5),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.0,),
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    ObjectUtil.isEmpty(commentStr)
                        ? Text(
                            "添加评论...",
                            style: TextStyle(
                                color: Colours.text_gray, fontSize: 15),
                          )
                        : Text(
                            commentStr,
                            style: TextStyle(
                                color: Colours.text_input, fontSize: 15),
                          ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
