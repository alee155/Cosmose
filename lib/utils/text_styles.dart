import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle title(double size, {Color color = AppColors.primaryDark}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      fontFamily: 'Raleway',
      color: color,
    );
  }

  static TextStyle body(double size, {Color color = AppColors.primaryDark}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      fontFamily: 'Raleway',
      color: color,
    );
  }

  static TextStyle bold(double size, {Color color = AppColors.primaryDark}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      fontFamily: 'Raleway',
      color: color,
    );
  }
}
