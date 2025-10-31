import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_style.dart';
import '../../widgets/build_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'Notification'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64.0,
              color: AppColors.darkGrey,
            ),
            SizedBox(height: 8.0),
            Text(
              'Not have Notification',
              style: textMeduim().copyWith(color: AppColors.darkGrey),
            ),
          ],
        ),
      ),
    );
  }
}
