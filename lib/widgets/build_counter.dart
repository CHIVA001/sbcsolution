import 'package:flutter/material.dart';
import '../core/themes/app_colors.dart';
import '../core/themes/app_style.dart';

class BuildCounter extends StatelessWidget {
  const BuildCounter({
    super.key,
    required this.qty,
    this.onPressedAdd,
    this.onPressedRemove,
    this.height = 40,
    this.radius = 24,
    this.bgColor = AppColors.backgroundColor,
    this.padding,
    this.borderColor = AppColors.darkGrey,
  });

  final String qty;
  final void Function()? onPressedRemove;
  final void Function()? onPressedAdd;
  final double height;
  final double radius;
  final Color bgColor;
  final Color borderColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12.0),
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: bgColor, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(
            icon: Icons.remove,
            color: AppColors.primaryColor,
            onPressed: onPressedRemove,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              qty.toString(),
              style: textMeduim().copyWith(fontSize: 16),
            ),
          ),
          _buildIconButton(
            icon: Icons.add,
            color: AppColors.primaryColor,
            onPressed: onPressedAdd,
          ),
        ],
      ),
    );
  }

  /// Small rounded button for + and -
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
