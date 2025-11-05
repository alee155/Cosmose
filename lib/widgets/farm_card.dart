import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FarmCard extends StatelessWidget {
  final String name;

  final String address;
  final String postalCode;
  final String? imageUrl; // Nullable image URL
  final VoidCallback onViewDetails;

  const FarmCard({
    super.key,
    required this.name,
    required this.address,
    required this.postalCode,
    this.imageUrl, // Accepting nullable image URL
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 2, // How much the shadow spreads
                blurRadius: 8, // Blur effect
                offset: Offset(2, 4), // X and Y offset for the shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Left Column: Farm details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        color: AppColors.green,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Postal Code: $postalCode",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        color: AppColors.green,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: onViewDetails,
                      child: Container(
                        height: 34.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.all(Radius.circular(4.r)),
                        ),
                        child: Center(
                          child: Text(
                            "View Details",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// Right Side: Image Container
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          height: 100.h,
                          width: 100.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        )
                      : Container(
                          height: 100.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
