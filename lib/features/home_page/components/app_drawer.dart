import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:cyspharama_app/features/auth/controllers/nav_bar_controller.dart';
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final _controller = Get.find<AuthController>();
  final _navCtr = Get.find<NavBarController>();
  void _changeLanguage(String newLangeuage) {
    final box = GetStorage();
    box.write('language', newLangeuage);
    // log(newLangeuage);
    Get.updateLocale(Locale(newLangeuage));
    setState(() {
      selectedLang = newLangeuage;
    });
  }

  void _closeDrawerAndDialog() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  String? selectedLang;
  @override
  void initState() {
    super.initState();
    selectedLang = Get.locale?.languageCode ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            margin: EdgeInsets.all(0),
            padding: EdgeInsetsGeometry.all(0),
            decoration: BoxDecoration(color: AppColors.primaryLight),
            child: Obx(() {
              final user = _controller.user.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user != null
                          ? NetworkImage('${user.image}')
                          : AssetImage('assets/images/defualt_user.png'),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      user != null ? user.fullName : 'loading...',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 16.0),
          // Home
          ListTile(
            leading: Icon(Icons.home),
            title: Text(MyText.home.tr),
            onTap: () {
              _navCtr.currentIndex = 0;
              Navigator.of(context).pop();
            },
          ),
          // Profile
          ListTile(
            leading: Icon(Icons.person),
            title: Text(MyText.profile.tr),
            onTap: () {
              _navCtr.currentIndex = 2;
              Navigator.of(context).pop();
            },
          ),
          // History
          ListTile(
            leading: Icon(Icons.history),
            title: Text(MyText.history.tr),
            onTap: () {
              _navCtr.currentIndex = 1;
              Navigator.of(context).pop();
            },
          ),
          // Change password
          ListTile(
            leading: Icon(Icons.password),
            title: Text(MyText.changePassword.tr),
            onTap: () {},
          ),
          // Contact Us
          ListTile(
            leading: Icon(Icons.contact_phone),
            title: Text(MyText.contactUs.tr),
            onTap: () {},
          ),
          // language
          ListTile(
            leading: Icon(Icons.language),
            title: Text(MyText.language.tr),
            onTap: () => Get.defaultDialog(
              title: MyText.language.tr,
              content: Column(
                children: [
                  // english
                  ListTile(
                    onTap: () async {
                      _changeLanguage('en');
                      _closeDrawerAndDialog();
                      Get.offAllNamed(AppRoutes.navBar);
                    },
                    trailing: Radio<String>(
                      value: 'en',
                      groupValue: selectedLang,
                      onChanged: (value) => _changeLanguage(value!),
                    ),
                    title: Text(MyText.english.tr),
                  ),
                  // khmer
                  ListTile(
                    onTap: () {
                      _changeLanguage('kh');
                      _closeDrawerAndDialog();
                      Get.offAllNamed(AppRoutes.navBar);
                    },
                    title: Text(MyText.khmer.tr),
                    trailing: Radio<String>(
                      value: 'kh',
                      groupValue: selectedLang,
                      onChanged: (value) => _changeLanguage(value!),
                    ),
                  ),
                  //
                  // chinese
                  ListTile(
                    onTap: () {
                      _changeLanguage('zh');
                      _closeDrawerAndDialog();
                      Get.offAllNamed(AppRoutes.navBar);
                    },
                    title: Text(MyText.chinese.tr),
                    trailing: Radio<String>(
                      value: 'zh',
                      groupValue: selectedLang,
                      onChanged: (value) => _changeLanguage(value!),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
          /////
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _controller.logout(),
              label: Text('Log Out'),
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
