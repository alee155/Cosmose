import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// **Reusable Elevated Button Widget**
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final double? height;
  final double? width;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48.h, // Default to 48.h if not provided
      width: width ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              color ?? AppColors.green, // Default color if not provided
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadius ?? 11.r), // Default border radius
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                textColor ?? Colors.white, // Default text color if not provided
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
