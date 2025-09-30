import 'package:get/get.dart';
import 'package:weone_shop/views/home_page/controllers/brand_controler.dart';
import 'package:weone_shop/views/home_page/controllers/category_controller.dart';
import 'package:weone_shop/views/home_page/controllers/product_controller.dart';
import 'package:weone_shop/views/home_page/controllers/slider_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SliderController(), fenix: true);
    Get.lazyPut(() => BrandController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
  }
}
