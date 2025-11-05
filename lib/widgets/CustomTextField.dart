import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// **Reusable Text Field Widget**
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final VoidCallback? togglePasswordVisibility;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.togglePasswordVisibility,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// **Row to show label and "Show/Hide" button beside it**
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
            if (isPassword && togglePasswordVisibility != null)
              GestureDetector(
                onTap: togglePasswordVisibility,
                child: Text(
                  obscureText ? "Show" : "Hide",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Raleway',
                    color: AppColors.green,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: AppColors.green,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.gray,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
}
