//


import '../../routes/app_routes.dart';
import '../localization/my_text.dart';

class AppImage {
  static const String logoApp = 'assets/logos/logo.png';
  static const String defualtUser = 'assets/images/defualt_user.png';
}

// dashboard
// ===========================================================
const String path = 'assets/icons';
final List<Map<String, dynamic>> dashboadItem = [
  {
    'icon': '$path/attendance_icon.png',
    'title': MyText.attendance,
    'page': () => AppRoutes.attendance,
  },
  {
    'icon': '$path/time_leave.png',
    'title': MyText.timeLeave,
    'page': () => AppRoutes.timeLeave,
  },
  {
    'icon': '$path/day_off_icon.png',
    'title': MyText.dayOff,
    'page': () => AppRoutes.dayOff,
  },
  {
    'icon': '$path/report_icon.png',
    'title': MyText.report,
    'page': () => AppRoutes.report,
  },
  {
    'icon': '$path/product_icon.png',
    'title': MyText.product,
    'page': () => AppRoutes.product,
  },
  {
    'icon': '$path/count_stock_icon.png',
    'title': MyText.countStock,
    'page': () => AppRoutes.countStock,
  },
  {
    'icon': '$path/sale_icon.png',
    'title': MyText.sales,
    'page': () => AppRoutes.sale,
  },
  {
    'icon': '$path/delivery_icon.png',
    'title': MyText.delivery,
    'page': () => AppRoutes.scanDispatch,
  },
  {
    'icon': '$path/customer_icon.png',
    'title': MyText.customer,
    'page': () => AppRoutes.customer,
  },
];
