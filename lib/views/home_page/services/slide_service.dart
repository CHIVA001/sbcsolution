import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weone_shop/constants/app_url.dart';
import 'package:weone_shop/views/home_page/models/slide_model.dart';

class SlideService {
  Future<List<SliderModel>> getSlider() async {
    final response = await http.get(
      Uri.parse(AppUrl.getSlider),
      headers: {'api-key': AppUrl.apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<dynamic> sliderJsonList = jsonDecode(data['slider']);

      return sliderJsonList
          .map((json) => SliderModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load slides');
    }
  }
}
