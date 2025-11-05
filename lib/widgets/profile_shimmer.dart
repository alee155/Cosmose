import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  Widget _shimmerContainer(
      {double height = 20, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image Shimmer
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),

        // Name Shimmer
        _shimmerContainer(height: 18, width: 120),

        SizedBox(height: 10.h),

        // Email Shimmer
        _shimmerContainer(height: 16, width: 180),

        SizedBox(height: 20.h),

        // Info Tiles Shimmer
        _shimmerContainer(height: 50),
        SizedBox(height: 10.h),
        _shimmerContainer(height: 50),
        SizedBox(height: 10.h),
        _shimmerContainer(height: 50),
        SizedBox(height: 10.h),
        _shimmerContainer(height: 50),
      ],
    );
  }
}
