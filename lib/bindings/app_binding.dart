import 'package:cyspharama_app/features/dashboad_page/attendance_page/controllers/shift_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/day_off_page/day_off_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/delivery_page/controller/delivery_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/report_page/report_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/sale/controller/sale_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/time_leave_page/time_leave_controller.dart';
import 'package:get/get.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/controllers/nav_bar_controller.dart';
import '../features/dashboad_page/attendance_page/controllers/attendance_controller.dart';
import '../features/dashboad_page/customer_page/controller/customer_controller.dart';
import '../features/products_page/controllers/cart_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => AuthController(), fenix: true);
    // Get.lazyPut(() => NavBarController(), fenix: true);
    Get.put(AuthController(), permanent: true);
    Get.put(NavBarController(), permanent: true);
    Get.lazyPut(() => AttendanceController(), fenix: true);
    Get.lazyPut(() => CustomerController(), fenix: true);
    Get.lazyPut(() => SaleController(), fenix: true);
    Get.lazyPut(() => TimeLeaveController(), fenix: true);
    Get.lazyPut(() => DayOffController(), fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => DeliveryController(), fenix: true);
    Get.put(ShiftController(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}
