import 'dart:developer';

import 'package:get/get.dart';
import 'package:weone_shop/views/home_page/models/slide_model.dart';

import '../services/slide_service.dart';

enum AppState { initial, loading, network, error }

class SliderController extends GetxController {
  var state = AppState.initial.obs;
  var sliderList = <SliderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fechSlider();
  }

  final SlideService _slideService = SlideService();

  Future<void> fechSlider() async {
    state(AppState.loading);
    try {
      final response = await _slideService.getSlider();
      sliderList.value = response;
      state(AppState.initial);
    } on Exception catch (e) {
      log('Slider Exception: $e');
      state(AppState.error);
    } catch (e) {
      log('Slider Network/Error: $e');
      state(AppState.network);
    }
  }
}
