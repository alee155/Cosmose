import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image or Banner
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),

            SizedBox(height: 16.h),

            // Description
            Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
              "when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway',
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),

            SizedBox(height: 24.h),

            // Order Info
            _infoRow("Order ID", "59020"),
            _infoRow("Quantity", "05"),
            _infoRow("Total Price", "NH 235"),
            _infoRow("Date", "2-5-2019"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
              color: AppColors.primaryDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Raleway',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
