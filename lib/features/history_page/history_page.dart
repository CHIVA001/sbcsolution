
import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_style.dart';
import '../../widgets/build_app_bar.dart';
import '../home_page/components/app_drawer.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final _keyState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyState,
      appBar: buildAppBarMain(scaffoldKey: _keyState),
      // drawer
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64.0, color: AppColors.darkGrey),
            SizedBox(height: 8.0),
            Text(
              'Not have history!',
              style: textMeduim().copyWith(color: AppColors.darkGrey),
            ),
          ],
        ),
      ),
    );
  }
}
