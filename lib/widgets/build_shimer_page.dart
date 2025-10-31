import 'package:flutter/material.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

import '../core/themes/app_colors.dart';

class BuildShimerPage extends StatelessWidget {
  const BuildShimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      color: AppColors.textLight,
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FadeShimmer(
                    width: double.infinity,
                    height: 100,
                    radius: 2,
                    baseColor: AppColors.bgColorLight,
                    highlightColor: AppColors.lightGrey,
                  ),
                ),
                SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer(
                      width: double.infinity,
                      height: 15,
                      radius: 2,
                      baseColor: AppColors.textLight,
                      highlightColor: AppColors.lightGrey,
                    ),
                    SizedBox(height: 8.0),
                    FadeShimmer(
                      width: double.infinity,
                      height: 15,
                      radius: 2,
                      baseColor: AppColors.bgColorLight,
                      highlightColor: AppColors.lightGrey,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
