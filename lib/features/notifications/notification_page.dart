import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';

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
