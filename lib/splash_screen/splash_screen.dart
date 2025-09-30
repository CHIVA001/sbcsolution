import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weone_shop/app_route.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/views/home_page/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// final _storage = StorageService();

void initPage() async {
  // final userId = await _storage.readData('user_id');
 await Future.delayed(Duration(seconds: 2));
Get.offAndToNamed(AppRoute.nabBar);
  // if (userId != null) {
  //   Get.offAndToNamed(AppRoute.nabBar);
  // } else {
  //   Get.offAndToNamed(AppRoute.login);
  // }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgLight,
      body: Center(child: Image.asset('assets/logo.png', width: 250)),
    );
  }
}
