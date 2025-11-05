import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FarmerProductShimmer extends StatelessWidget {
  const FarmerProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.grey[300], // Background color
      ),
      child: Stack(
        children: [
          // Shimmer for Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 150.h,
                width: 200.w,
                color: Colors.white,
              ),
            ),
          ),

          // Shimmer for Title and Price
          Positioned(
            bottom: 10.h,
            left: 10.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16.h,
                    width: 120.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                // Price Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 14.h,
                    width: 60.w,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Shimmer for Avatar
          Positioned(
            bottom: 10.h,
            right: 10.w,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
