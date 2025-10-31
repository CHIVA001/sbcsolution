
import '../core/themes/app_style.dart';
import '/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class BuildRowIconText extends StatelessWidget {
  const BuildRowIconText({
    super.key,
    required this.icon,
    required this.text,
    this.mainAlignment = MainAxisAlignment.center,
  });
  final IconData icon;
  final String text;
  final MainAxisAlignment mainAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: mainAlignment,
        children: [
          Icon(icon, size: 24.0, color: AppColors.textPrimary),
          SizedBox(width: 8.0),
          Text(text, style: textMeduim()),
        ],
      ),
    );
  }
}
