import 'package:get/get.dart';

class NavBarController extends GetxController{

  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;
  
  set currentIndex(int value) => _currentIndex.value = value;

}