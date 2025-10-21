import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/themes/app_colors.dart';

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

CachedNetworkImage imageProduct({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit? fit,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit,
    errorWidget: (context, url, error) =>
        const Icon(Icons.error, color: Color.fromARGB(73, 255, 82, 82)),
    placeholder: (context, url) =>
        Container(width: width, height: height, color: AppColors.bgColorLight),
  );
}
