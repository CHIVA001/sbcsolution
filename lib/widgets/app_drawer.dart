import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:weone_shop/auth/auth_controller.dart';
import 'package:weone_shop/constants/app_color.dart';
import 'package:weone_shop/views/nav_bar/nav_bar_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtr = Get.find<NavBarController>();
    final authCtr = Get.find<AuthController>();
    return Drawer(
      backgroundColor: AppColors.lightBg,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppColors.lightBgLight),
              child: Image.asset('assets/logo.png', height: 100),
            ),
          ),

          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(RemixIcons.home_4_line),
                  title: const Text('Home'),
                  onTap: () {
                    navCtr.changeTab(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(RemixIcons.shopping_bag_3_line),
                  title: const Text('Shopping'),
                  onTap: () {
                    navCtr.changeTab(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(RemixIcons.menu_search_line),
                  title: const Text('Category'),
                  onTap: () {
                    navCtr.changeTab(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(RemixIcons.shopping_cart_2_line),
                  title: const Text('Cart'),
                  onTap: () {
                    navCtr.changeTab(3);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(RemixIcons.heart_3_line),
                  title: const Text('Favorite'),
                  onTap: () {
                    navCtr.changeTab(4);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // _buildListTile(
          //   onTap: () => authCtr.logout(),
          //   icon: RemixIcons.logout_box_r_line,
          //   title: 'Log out',
          // ),
          // // Footer
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     "Version 1.0.0",
          //     style: TextStyle(color: Colors.grey[600], fontSize: 12),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    void Function()? onTap,
    Color iconColor = Colors.red,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24.0, color: iconColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0, color: AppColors.lightText),
      ),
      onTap: onTap,
    );
  }
}
