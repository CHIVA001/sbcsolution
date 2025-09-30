import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weone_shop/app_route.dart';
import 'package:weone_shop/bindings/app_binding.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:get/get.dart';

import 'auth/auth_controller.dart';

void main() async{
  runApp(MyApp());
   await GetStorage.init(); 
  Get.put(AuthController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.lightBgLight,
          scrolledUnderElevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightBgLight,
        ),
        scaffoldBackgroundColor: AppColors.lightBg,
      ),
      initialBinding: AppBinding(),
      getPages: AppRoute.pages,
      initialRoute: AppRoute.splash,
    );
  }
}
