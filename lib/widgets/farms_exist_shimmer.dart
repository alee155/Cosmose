import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class FarmsExistShimmer extends StatelessWidget {
  const FarmsExistShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
