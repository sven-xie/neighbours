import 'package:flutter/material.dart';
import 'package:neighbours/models/user_info.dart';
import 'package:neighbours/res/res_index.dart';
import 'package:neighbours/utils/util_index.dart';

typedef OnPopupMenuSelect = Function(String);

class CommonUserBar extends StatelessWidget {
  final UserInfo userInfo;
  final String time;
  final String address;
  final List<String> menuList;
  final OnPopupMenuSelect onPopupMenuSelect;

  const CommonUserBar(
      {this.userInfo,
      this.time,
      this.address,
      this.menuList,
      this.onPopupMenuSelect});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(left: 0.0, top: 8.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Img(userInfo.avatarUrl, isCircle: true, radius: 20),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CText(
                      userInfo.nickname,
                      textSize: 16,
                      textColor: Colours.text_title,
                      bold: true,
                    ),
                    Row(
                      children: <Widget>[
                        CText(
                          time,
                          textSize: 10,
                          textColor: Colours.text_gray,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        CText(
                          address,
                          textSize: 10,
                          textColor: Colours.text_gray,
                          drawablePadding: 4,
                          icon: Icons.my_location,
                          iconSize: 10.0,
                          drawableDirection: DrawableDirection.left,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          menuList != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.all(3.0),
                    icon: new Icon(
                      Icons.arrow_drop_down,
                      color: Colours.gray_99,
                    ),
                    onSelected: (String menuName) {
                      onPopupMenuSelect(menuName);
                    },
                    itemBuilder: (BuildContext context) =>
                        menuList.map((String menuName) {
                          return new PopupMenuItem<String>(
                              value: menuName,
                              child: Center(child: new Text(menuName)));
                        }).toList(),
                  ))
              : Container(),
        ],
      ),
      // padding: const EdgeInsets.only(top: 10.0),
    );
  }
}
