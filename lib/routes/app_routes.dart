import '/features/dashboad_page/customer_page/add_customer.dart';
import '../features/products_page/cart/confirm_cart.dart';
import '/features/products_page/products_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_nav_bar_page.dart';
import '../core/utils/splash_screen/splash_screen_page.dart';
import '../features/auth/login_page.dart';
import '../features/dashboad_page/attendance_page/attenance_page.dart';
import '../features/dashboad_page/count_stock_page.dart';
import '../features/dashboad_page/customer_page/customer_page.dart';
import '../features/dashboad_page/day_off_page/add_day_off.dart';
import '../features/dashboad_page/day_off_page/day_off_page.dart';
import '../features/dashboad_page/delivery_page/delivery_page.dart';
import '../features/dashboad_page/delivery_page/scan_dispatch_page.dart';
import '../features/dashboad_page/report_page/report_page.dart';
import '../features/dashboad_page/sale/sale_page.dart';
import '../features/dashboad_page/time_leave_page/add_time_leave.dart';
import '../features/dashboad_page/time_leave_page/time_leave_page.dart';
import '../features/home_page/home_page.dart';
import '../features/notifications/notification_page.dart';
import '../features/products_page/controllers/product_controller.dart';
import '../features/products_page/models/product_model.dart';
import '../features/products_page/product_detail.dart';

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
  static const String notification = '/notification';
  static const String confirmCart = '/confirmCart';
  static const String addCustomer = '/addCustomer';

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
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: timeLeave,
      page: () => TimeLeavePage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: dayOff,
      page: () => DayOffPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: report,
      page: () => ReportPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: product,
      page: () => ProductsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: countStock,
      page: () => CountStockPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: sale,
      page: () => SalesPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: delivery,
      page: () => DeliveryPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: customer,
      page: () => CustomerPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: scanDispatch,
      page: () => ScanDispatchPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: splash,
      page: () => SplashScreenPage(),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addTimeLeave,
      page: () => AddTimeLeave(),
      customTransition: MyCustomTransition(),
    ),
    GetPage(
      name: addDayoff,
      page: () => AddDayOff(),
      // customTransition: MyCustomTransition(),
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: notification,
      page: () => NotificationPage(),
      // transition: Transition.rightToLeft,
      customTransition: MyCustomTransition(),
    ),
    // GetPage(name: '/products', page: () => ProductsPage()),
    GetPage(
      name: '$product/:id',
      page: () {
        final String id = Get.parameters['id']!;
        if (id.isEmpty) return ProductsPage();
        final product = getProductById(id);
        return ProductDetail(product: product);
      },
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: confirmCart,
      page: () => ConfirmCart(),
      transitionDuration: Duration(milliseconds: 200),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: addCustomer,
      page: () => AddCustomer(),
      transitionDuration: Duration(milliseconds: 200),
      transition: Transition.rightToLeft,
    ),
  ];
}

ProductModel getProductById(String id) {
  final controller = Get.find<ProductsController>();
  return controller.products.firstWhere(
    (p) => p.id == id,
    orElse: () => throw Exception('Product with id $id not found'),
  );
}

class MyCustomTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
