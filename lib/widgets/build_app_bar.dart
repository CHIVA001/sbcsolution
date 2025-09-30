import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/views/nav_bar/nav_bar_controller.dart';

AppBar buildAppBar() {
  final navCtr = Get.find<NavBarController>();
  return AppBar(
    leading: Builder(
      builder: (context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(RemixIcons.menu_2_fill),
      ),
    ),
    title: Row(
      children: [
        Image.asset('assets/logo.png', width: 100),
        Spacer(),
        IconButton(
          onPressed: () => navCtr.changeTab(2),
          icon: Icon(RemixIcons.search_2_line),
        ),
      ],
    ),
  );
}
