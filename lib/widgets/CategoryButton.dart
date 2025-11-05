import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CategoryButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;

  const CategoryButton({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      width: 65.w,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.green : AppColors.lightGray,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 23.w,
              height: 23.h,
              color: isSelected ? Colors.white : Colors.black,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyles.body(12.sp).copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
