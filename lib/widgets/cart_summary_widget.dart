import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartSummary extends StatelessWidget {
  final String subtotal;
  final String tax;
  final String grandTotal;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Subtotal:",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
            Text(
              subtotal,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tax:",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
            Text(
              tax,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Grand Total:",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
            Text(
              grandTotal,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Raleway',
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
