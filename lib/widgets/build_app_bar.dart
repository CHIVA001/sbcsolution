import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/themes/app_colors.dart';
import '../core/utils/app_image.dart';

AppBar buildAppBar({
  required String title,
  Widget? action,
  void Function()? onPressed,
}) {
  return AppBar(
    leading: IconButton(
      onPressed:
          onPressed ??
          () {
            Get.back();
          },

      icon: Icon(Icons.arrow_back),
    ),
    title: Text(title),
    actions: [action ?? SizedBox.shrink()],
    centerTitle: true,
  );
}

AppBar buildAppBarMain({required GlobalKey<ScaffoldState> scaffoldKey}) {
  return AppBar(
    backgroundColor: AppColors.bgColorLight,
    centerTitle: false,
    leading: IconButton(
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
      icon: Icon(Icons.menu, color: AppColors.textPrimary),
    ),
    title: Image.asset(AppImage.logoApp, height: 40, width: 80),
  );
}
