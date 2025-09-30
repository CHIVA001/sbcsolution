import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

CachedNetworkImage cachedImgae({required String imageUrl}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    errorWidget: (context, url, error) =>
        const Icon(Icons.error, color: Color.fromARGB(73, 255, 82, 82)),
    placeholder: (context, url) => SizedBox(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(
        color: AppColors.backgroundColor,
        strokeWidth: 1.0,
      ),
    ),
  );
}
