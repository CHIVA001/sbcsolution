import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings/app_binding.dart';
import 'core/localization/transtation.dart';
import 'core/themes/app_colors.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/dashboad_page/attendance_page/controllers/shift_controller.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
   Get.put(ShiftController(), permanent: true);
    Get.put(AuthController(), permanent: true);
  await AppTranslations.loadTranslations(['en', 'kh', 'zh']);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final String? savedLanguage = box.read('language');

    return GetMaterialApp(
      title: 'Cyspharama app',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: savedLanguage != null
          ? Locale(savedLanguage)
          : const Locale('en'),
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        //
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgColorLight),
        //
        scaffoldBackgroundColor: AppColors.backgroundColor,

        // floating action button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          iconSize: 32.0,
          focusColor: AppColors.primaryColor,
          highlightElevation: 0,
        ),

        // app bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bgColorLight,
          scrolledUnderElevation: 0,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 24.0,
            color: AppColors.textPrimary,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),

          //
          iconTheme: IconThemeData(color: AppColors.textPrimary, size: 24.0),
        ),
        //---------------------------------
        listTileTheme: const ListTileThemeData(
          iconColor: AppColors.primaryColor,
          textColor: AppColors.textPrimary,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        radioTheme: const RadioThemeData(
          fillColor: WidgetStatePropertyAll(AppColors.primaryColor),
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      initialBinding: AppBinding(),
      // initialRoute: isLogin ? AppRoutes.navBar : AppRoutes.login,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
    //   },
    // );
  }
}
