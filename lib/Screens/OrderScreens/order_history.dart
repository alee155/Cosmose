import 'package:cosmose/Screens/OrderScreens/order_details_screen.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        title: Text(
          "Order History",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: 13,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        separatorBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Divider(),
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {  
             Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrderDetailsScreen()),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.button2,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  Container(
                    height: 53.h,
                    width: 52.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _rowText("Apple", "Success", AppColors.primaryDark,
                            AppColors.green),
                        SizedBox(height: 4.h),
                        _rowText("RM 4053", "5900", AppColors.primaryDark,
                            AppColors.primaryDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowText(
      String left, String right, Color leftColor, Color rightColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: leftColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: rightColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
