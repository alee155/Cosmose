import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cosmose/utils/app_colors.dart';

class ChangePasswordFields extends StatelessWidget {
  final String label;
  final RxBool isVisible;
  final TextEditingController controller;

  const ChangePasswordFields({
    super.key,
    required this.label,
    required this.isVisible,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => TextField(
            controller: controller,
            obscureText: !isVisible.value,
            cursorColor: AppColors.green,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
              filled: true,
              fillColor: Color(0xFFEFF1F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible.value ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () => isVisible.value = !isVisible.value,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
