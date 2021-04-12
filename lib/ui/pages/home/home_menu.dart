import 'package:flutter/material.dart';
import 'package:neighbours/models/home_model.dart';
import 'package:neighbours/utils/util_index.dart';
import 'package:neighbours/ui/widgets/button/button_widget.dart';

class HomeMenu extends StatelessWidget {
  final List<MenuInfo> infos;

  HomeMenu(this.infos);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GridView.count(
        padding: const EdgeInsets.all(5.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 4,
        children: infos.map((menuInfo) => menuItem(menuInfo, context)).toList(),
      ),
    );
  }

  Widget menuItem(MenuInfo info, BuildContext context) {
    return IconTextColumnButton(
                          icon: info.imagePath,
                          text: info.title,
                          onTap: () {
                            Utils.showToast(info.title);
                          },
                        );
  }
}
