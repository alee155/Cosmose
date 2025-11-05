import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final int itemCount; // Number of shimmer items to show
  const ShimmerLoader({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Ensures items align at the top
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(itemCount, (index) => _shimmerItem()),
      ),
    );
  }

  Widget _shimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: Colors.white,
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsets.only(right: 10.w),
            height: 10.h,
            width: 65.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
          ),
        ],
      ),
    );
  }
}
