import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/localization/my_text.dart';
import '../../../core/themes/app_colors.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/controllers/nav_bar_controller.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _controller = Get.put(AuthController());
  final _navCtr = Get.put(NavBarController());
  String? selectedLang;

  @override
  void initState() {
    super.initState();
    selectedLang = Get.locale?.languageCode ?? 'en';
  }

  bool _changeLanguage(String newLanguage) {
    final box = GetStorage();
    box.write('language', newLanguage);
    Get.updateLocale(Locale(newLanguage));
    setState(() => selectedLang = newLanguage);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final year = DateTime.now().year;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(0),
      ),
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        children: [
          Obx(() {
            final user = _controller.user.value;
            return Container(
              padding: EdgeInsets.fromLTRB(8, 50, 8, 16),
              color: AppColors.primaryColor,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user?.image != null
                        ? NetworkImage(user!.image!)
                        : const AssetImage('assets/images/defualt_user.png')
                              as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.fullName ?? 'Loading...',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '@${user?.username}',
                    style: const TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(Icons.home, MyText.home.tr, () {
                  _navCtr.currentIndex = 0;
                  Get.back();
                }),
                _drawerItem(Icons.person, MyText.profile.tr, () {
                  _navCtr.currentIndex = 1;
                  Get.back();
                }),
                _drawerItem(Icons.password, MyText.changePassword.tr, () {}),
                _drawerItem(Icons.contact_phone, MyText.contactUs.tr, () {}),
                _drawerItem(Icons.language, MyText.language.tr, () {
                  _showLanguageDialog(context);
                }),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                _controller.logout();
                _navCtr.currentIndex = 0;
              },
              icon: Icon(Icons.logout, size: 20, fontWeight: FontWeight.w500),
              label: Text(
                'Log Out',
                // style: textdefualt().copyWith(
                //   color: AppColors.textLight,
                //   fontWeight: FontWeight.w500,
                // ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Column(
              children: [
                Divider(color: Colors.grey.withOpacity(0.3)),
                const SizedBox(height: 4),
                Text(
                  '© $year SBC SOLUTION. All rights reserved.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  Language dialog
  void _showLanguageDialog(BuildContext context) {
    Get.defaultDialog(
      title: MyText.language.tr,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      content: Column(
        children: [
          _languageOption('en', MyText.english.tr),
          _languageOption('kh', MyText.khmer.tr),
        ],
      ),
      radius: 12,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white,
    );
  }

  // Drawer item builder
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    );
  }

  //  Language item
  Widget _languageOption(String code, String name) {
    return ListTile(
      title: Text(name),
      trailing: Radio<String>(
        value: code,
        groupValue: selectedLang,
        onChanged: (value) {
          _changeLanguage(value!);
          Get.offAllNamed(AppRoutes.navBar);
          _navCtr.currentIndex = 0;
        },
      ),
      onTap: () {
        _changeLanguage(code);
        Get.offAllNamed(AppRoutes.navBar);
        _navCtr.currentIndex = 0;
      },
    );
  }
}
