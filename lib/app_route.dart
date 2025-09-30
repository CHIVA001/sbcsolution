import 'package:get/get.dart';
import 'package:weone_shop/auth/login_page.dart';
import 'package:weone_shop/splash_screen/splash_screen.dart';
import 'package:weone_shop/views/nav_bar/nav_bar_app.dart';

class AppRoute {
  static const String login = '/login';
  static const String nabBar = '/nav_bar';
  static const String splash = '/splash';
  // static const String login = '/login';

  static List<GetPage> pages = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: nabBar, page: () => NavBarApp()),
    GetPage(name: splash, page: () => SplashScreen()),
  ];
}
