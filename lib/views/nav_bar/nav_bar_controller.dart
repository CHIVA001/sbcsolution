import 'package:get/get.dart';

class NavBarController extends GetxController {
  var currentIndex = 0.obs;

  // Change
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
