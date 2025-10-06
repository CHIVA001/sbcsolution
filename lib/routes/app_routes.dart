import 'package:cyspharama_app/bottom_nav_bar_page.dart';
import 'package:cyspharama_app/core/utils/splash_screen/splash_screen_page.dart';
import 'package:cyspharama_app/features/auth/login_page.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/attenance_page.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/add_day_off.dart';
import 'package:cyspharama_app/features/dashboad_page/time_leave_page/add_time_leave.dart';
import 'package:cyspharama_app/features/home_page/home_page.dart';
import 'package:get/get.dart';
import '../features/dashboad_page/count_stock_page.dart';
import '../features/dashboad_page/customer_page/customer_page.dart';
import '../features/dashboad_page/day_off_page/day_off_page.dart';
import '../features/dashboad_page/delivery_page/delivery_page.dart';
import '../features/dashboad_page/delivery_page/scanner_page.dart';
import '../features/dashboad_page/product_page/product_page.dart';
import '../features/dashboad_page/report_page/report_page.dart';
import '../features/dashboad_page/sale/sale_page.dart';
import '../features/dashboad_page/time_leave_page/time_leave_page.dart';

class AppRoutes {
  static const String splash = '/splash';

  static const String login = '/login';
  static const String navBar = '/nav_bar';
  static const String home = '/home';
  // dashboard
  static const String attendance = '/attendance';
  static const String timeLeave = '/time_leave';
  static const String dayOff = '/day_off';
  static const String report = '/report';
  static const String product = '/product';
  static const String countStock = '/count_stock';
  static const String sale = '/sale';
  static const String delivery = '/delivery';
  static const String customer = '/customer';
  static const String addTimeLeave = '/add_time_leave';
  static const String addDayoff = '/add_day_off';
  static const String dayOffDetail = '/day_off_detail';
  static const String reportDetail = '/report_detail';
  static const String scanDispatch = '/scan_dispatch';

  static List<GetPage> routes = [
    //
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: navBar, page: () => BottomNavBarPage()),
    // dashboard
    //===========================================================
    GetPage(
      name: attendance,
      page: () => AttendancePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: timeLeave,
      page: () => TimeLeavePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: dayOff,
      page: () => DayOffPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: report,
      page: () => ReportPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: product,
      page: () => ProductPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: countStock,
      page: () => CountStockPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: sale,
      page: () => SalesPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: delivery,
      page: () => DeliveryPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: customer,
      page: () => CustomerPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: scanDispatch,
      page: () => ScanDispatchPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: splash,
      page: () => SplashScreenPage(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addTimeLeave,
      page: () => AddTimeLeave(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: addDayoff,
      page: () => AddDayOff(),
      transition: Transition.downToUp,
    ),
    
    // GetPage(
    //   name: reportDetail,
    //   page: () => ReportDetail(),
    //   transition: Transition.downToUp,
    // ),
    // GetPage(
    //   name: dayOffDetail,
    //   page: () => DayOffDetail(),
    //   transition: Transition.rightToLeft,
    // ),
    //===========================================================
  ];
}
