import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _keys = {};

  static Future<void> loadTranslations(List<String> languages) async {
    for (var lang in languages) {
      final String jsonString = await rootBundle.loadString('lib/core/localization/$lang.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final Map<String, String> stringMap = {};
      jsonMap.forEach((key, value) {
        stringMap[key] = value.toString();
      });
      _keys[lang] = stringMap;
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _keys;
}