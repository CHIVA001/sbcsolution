import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/localization/my_text.dart';
import '../../widgets/build_app_bar.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: MyText.delivery.tr),
      body: Center(child: Text('Delivery Page will update soon')),
    );
  }
}
