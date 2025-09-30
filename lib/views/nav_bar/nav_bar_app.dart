import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/views/home_page/controllers/product_controller.dart';
import '../cart_page/cart_page.dart';
import '../favorite_page/favorite_page.dart';
import '../category_page/category_page.dart';
import '../home_page/home_page.dart';
import '../shopping_page/shopping_page.dart';
import 'nav_bar_controller.dart';
import '../cart_page/cart_controller.dart';

class NavBarApp extends StatelessWidget {
  NavBarApp({super.key});

  final NavBarController controller = Get.put(NavBarController());
  final CartController cartController = Get.put(CartController());
  final ProductController favController = Get.put(ProductController());

  final List<Widget> pages = [
    HomePage(),
    ShoppingPage(),
    CategoryPage(),
    CartPage(),
    FavoritePage(),
  ];

  Future<bool> _onWillPop(BuildContext context) async {
    if (controller.currentIndex.value != 0) {
      controller.changeTab(0);
      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Obx(
        () => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: AppColors.lightTextMuted,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(RemixIcons.home_4_line),
                activeIcon: Icon(RemixIcons.home_4_fill),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(RemixIcons.shopping_bag_3_line),
                activeIcon: Icon(RemixIcons.shopping_bag_3_fill),
                label: 'Shopping',
              ),
              const BottomNavigationBarItem(
                icon: Icon(RemixIcons.menu_search_line),
                activeIcon: Icon(RemixIcons.menu_search_fill),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: Obx(() {
                  final count = cartController.totalItems;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(RemixIcons.shopping_cart_2_line),
                      if (count > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                activeIcon: Obx(() {
                  final count = cartController.totalItems;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(RemixIcons.shopping_cart_2_fill),
                      if (count > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Obx(() {
                  final count = favController.favorites.length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(RemixIcons.heart_3_line),
                      if (count > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                activeIcon: Obx(() {
                  final count = favController.favorites.length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(RemixIcons.heart_3_fill),
                      if (count > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                label: 'Favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
