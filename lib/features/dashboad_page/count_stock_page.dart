import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountStockPage extends StatelessWidget {
  const CountStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: MyText.countStock.tr),
      body: Center(child: Text('Count Stock Page will update soon')),
    );
  }
}
