import 'package:flutter/material.dart';

InputDecoration defaultstyleInput({
  required String hint,

  IconData? prefixIcon,
  IconData? suffixIcon,
  bool showSuffix = false,
  double bottom = 0,
}) => InputDecoration(
  hintText: hint,
  label: Padding(
    padding: EdgeInsets.only(bottom: bottom),
    child: Text(hint),
  ),
  prefixIcon: prefixIcon != null
      ? Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Icon(prefixIcon),
        )
      : null,
  suffixIcon: showSuffix ? Icon(suffixIcon) : null,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14.0),
);
