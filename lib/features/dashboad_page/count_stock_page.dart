import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/localization/my_text.dart';
import '../../widgets/build_app_bar.dart';

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
