import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:neighbours/common/component_index.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/routers/application.dart';
import 'package:neighbours/ui/widgets/special_text/my_special_text_span_builder.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:extended_text/extended_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:url_launcher/url_launcher.dart';

typedef OnBottomItemSelect = Function(int);

class CommonCommonView extends StatelessWidget {
  final String content;
  final bool isDetailPage;

  const CommonCommonView({
    this.content,
    this.isDetailPage,
  });

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        ExtendedText(
          "'映射和这个 PODO 文件之间没有映射。\$issue甚至\$实体名称也不匹配。@我知道 我知道。 我们还没有完成。\$我们必须\$将这些类成员映射到 json 对象。为此，我们需要创建一个 factory 方法。根据 Dart 文档，我们在实现一个构造函数时使用 factory 关键字时，这个构造函数不会总是创建其类的新实例，而这正是我们现在所需要的'",
          onSpecialTextTap: (dynamic parameter) {
            if (parameter.startsWith("\$")) {
              if (parameter.contains("issue")) {
                launch("https://github.com/flutter/flutter/issues/26748");
              } else {
                launch("https://github.com/fluttercandies");
              }
            } else if (parameter.startsWith("@")) {
              launch("mailto:zmtzawqlp@live.com");
            }
          },
          specialTextSpanBuilder: MySpecialTextSpanBuilder(),
          //overflow: TextOverflow.ellipsis,
          overFlowTextSpan: OverFlowTextSpan(children: <TextSpan>[
            TextSpan(text: '  \u2026  '),
            TextSpan(
                text: "全文",
                style: TextStyle(
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch("https://github.com/fluttercandies/extended_text");
                  })
          ], 
          ),
          maxLines: 3,
        ),
        _getImageView(context),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          color: Colours.divider,
        ),
        _getActionBar(),
      ],
    );
  }

  Widget _getImageView(BuildContext context) {
    List<String> pics = [
      "https://pic3.zhimg.com/v2-b67be50be51e2e6d6112a64528683b09_b.jpg",
      "https://pic4.zhimg.com/v2-a7493d69f0d8f849c6345f8f693454f3_200x112.jpg",
      "https://pic2.zhimg.com/50/v2-710b7a6fea12a7203945b666790b7181_hd.jpg",
      "https://pic3.zhimg.com/v2-b67be50be51e2e6d6112a64528683b09_b.jpg",
      "https://pic4.zhimg.com/v2-a7493d69f0d8f849c6345f8f693454f3_200x112.jpg",
      "https://pic2.zhimg.com/50/v2-710b7a6fea12a7203945b666790b7181_hd.jpg",
      "https://pic3.zhimg.com/v2-b67be50be51e2e6d6112a64528683b09_b.jpg",
      "https://pic4.zhimg.com/v2-a7493d69f0d8f849c6345f8f693454f3_200x112.jpg",
      "https://pic2.zhimg.com/50/v2-710b7a6fea12a7203945b666790b7181_hd.jpg",
    ];

    int rows = 1;
    if (pics.length <= 3) {
      rows = pics.length;
    } else if (pics.length <= 6) {
      rows = 3;
      if (pics.length == 4) {
        rows = 2;
      }
    } else {
      rows = 3;
    }

    if (rows == 1) {
      return Container(
        padding: const EdgeInsets.only(top:10.0),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            Application.router
                .navigateTo(context, "/photoview");
          },
          child: ExtendedImage.network(
            pics[0],
            cache: true,
            fit: BoxFit.cover,
            width: ScreenUtil.getInstance().setWidth(700),
            height: ScreenUtil.getInstance().setWidth(700),
             alignment: Alignment.topLeft,
          ),
        ),
      );
    }
    // var json = jsonEncode(Utf8Encoder().convert(pics));

    return GridView(
      padding: const EdgeInsets.only(top: 10.0, right: 8.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rows,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1.0,
      ),
      children: pics.map<Widget>((imageUrl) {
        return GestureDetector(
          
          onTap: () {
            NavigatorUtil.pushPhotoViewBrowser(context,pics:pics,currentIndex:pics.indexOf(imageUrl));
          },
          child: ExtendedImage.network(
            imageUrl,
            cache: true,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }

  Widget _getActionBar() {
    return new Container(
      height: 45,
      width: double.infinity,
      child: new Row(
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Utils.showToast("点赞");
                },
                child: Center(
                  child: CText(
                    "23",
                    textSize: 14,
                    drawablePadding: 3,
                    textColor: Colours.gray_99,
                    drawableDirection: DrawableDirection.left,
                    imageAsset: Utils.getImgPath("ic_home_like"),
                    imageWidth: 25,
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Utils.showToast("评论");
                },
                child: Center(
                  child: CText(
                    "23",
                    textSize: 14,
                    drawablePadding: 3,
                    textColor: Colours.gray_99,
                    drawableDirection: DrawableDirection.left,
                    imageAsset: Utils.getImgPath("ic_home_reply"),
                    imageWidth: 25,
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Utils.showToast("收藏");
                },
                child: Center(
                  child: CText(
                    "23",
                    textSize: 14,
                    drawablePadding: 3,
                    textColor: Colours.gray_99,
                    drawableDirection: DrawableDirection.left,
                    imageAsset: Utils.getImgPath("ic_home_repost"),
                    imageWidth: 25,
                  ),
                ),
              )),
          new Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Utils.showToast("分享");
                },
                child: Center(
                  child: CText(
                    "23",
                    textSize: 14,
                    drawablePadding: 3,
                    textColor: Colours.gray_99,
                    drawableDirection: DrawableDirection.left,
                    imageAsset: Utils.getImgPath("ic_home_share"),
                    imageWidth: 25,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
