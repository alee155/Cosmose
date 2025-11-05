import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoyaltyCard extends StatelessWidget {
  final double widthPercentage;
  final String price;
  final VoidCallback onIconTap;
  final VoidCallback onButtonTap;
  final VoidCallback oncancelTap; // This will be used to hide the card

  const LoyaltyCard({
    super.key,
    required this.widthPercentage,
    required this.price,
    required this.onIconTap,
    required this.onButtonTap,
    required this.oncancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 59.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(90.r)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  size: 30,
                  Icons.shopping_cart,
                  color: AppColors.green,
                ),
                onPressed: onIconTap,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      price, // Dynamic price text
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 150.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: AppColors.loyalcard,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        Container(
                          width:
                              150 * widthPercentage, // Dynamic progress width
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onButtonTap,
                child: Container(
                  height: 28.h,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Center(
                    child: Text(
                      'payer',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: oncancelTap, // Call the function to hide the card
                child: Icon(
                  size: 20,
                  Icons.close_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
