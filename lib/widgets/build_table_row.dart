import '/core/themes/app_style.dart';
import '/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class BuildTableRow {
  static TableRow build({
    required String name,
    required String qty,
    required String unit,
    required String discount,
    required String amount,
    Color bgColor = AppColors.textLight,
    Color textColor = AppColors.textPrimary,
    double textSize = 13.0,
    FontWeight fontWeight = FontWeight.w400,
    TextAlign textAlign = TextAlign.start,
  }) {
    return TableRow(
      decoration: BoxDecoration(color: bgColor),
      children: [
        _cell(name, fontWeight, textColor, textSize, textAlign),
        _cell(qty, fontWeight, textColor, textSize, textAlign),
        _cell(unit, fontWeight, textColor, textSize, textAlign),
        _cell(discount, fontWeight, textColor, textSize, textAlign),
        _cell(amount, fontWeight, textColor, textSize, textAlign),
      ],
    );
  }

  static Widget _cell(
    String text,
    FontWeight fontWeight,
    Color color,
    double size,
    TextAlign textAlign,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        text,
        style: textdefualt().copyWith(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
