import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cosmose/utils/app_colors.dart';

class CheckoutSummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const CheckoutSummaryRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
