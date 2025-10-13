import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/auth/controllers/nav_bar_controller.dart';
import 'package:cyspharama_app/features/history_page/history_page.dart';
import 'package:cyspharama_app/features/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/home_page/home_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBarPage> {
  DateTime? _lastPressed;
  final _controller = Get.find<NavBarController>();
  final List<Widget> _pages = [HomePage(), HistoryPage(), ProfilePage()];

  Future<bool> _onWillPop() async {
    if (_controller.currentIndex != 0) {
      setState(() => _controller.currentIndex = 0);
      return false;
    }

    final now = DateTime.now();
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;

      Get.snackbar(
        "Exit",
        "Press back again to exit app",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );

      return false;
    }
    return true;
  }

  // @override
  // void initState() async {
  //   await SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _onWillPop,
      // onWillPop: () async {
      //   Get.snackbar('title', 'message');
      //   return false;
      // },
      child: Obx(
        () => Scaffold(
          body: IndexedStack(index: _controller.currentIndex, children: _pages),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _controller.currentIndex,
            onTap: (index) => _controller.currentIndex = index,
            backgroundColor: AppColors.bgColorLight,
            elevation: 0,
            selectedItemColor: AppColors.primaryLight,
            unselectedItemColor: AppColors.darkGrey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: MyText.home.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: MyText.history.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: MyText.profile.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
