import 'package:cosmose/controllers/wishlist_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/wishlist_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WishListScreen extends StatelessWidget {
  final LoginResponse loginResponse;

  WishListScreen({super.key, required this.loginResponse}) {
    final WishlistController controller = Get.put(WishlistController());
    controller.setToken(loginResponse.token);
    controller.fetchWishList();
  }

  @override
  Widget build(BuildContext context) {
    final WishlistController controller = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        automaticallyImplyLeading: false,
        title: Text(
            "WishList",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Raleway',
              color: AppColors.primaryDark,
            ),
          )
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            // Wishlist Items Count & Delete Button
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Items (${controller.wishlist.length})",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: AppColors.primaryDark,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isDeleteMode.value
                            ? Icons.delete_forever
                            : Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if (controller.isDeleteMode.value) {
                          controller.deleteSelectedItems();
                        } else {
                          controller.toggleDeleteMode();
                        }
                      },
                    ),
                  ],
                )),

            // Wishlist Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return WishlistShimmer();
                }

                if (controller.wishlist.isEmpty) {
                  return Center(child: Text("No items in wishlist"));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemCount: controller.wishlist.length,
                  itemBuilder: (context, index) {
                    final item = controller.wishlist[index];

                    return GestureDetector(
                      onTap: controller.isDeleteMode.value
                          ? () => controller.toggleSelection(item.productId)
                          : null,
                      child: Obx(() => Container(
                            margin: EdgeInsets.symmetric(vertical: 5.h),
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: controller.selectedItems
                                      .contains(item.productId)
                                  ? Colors.red.withOpacity(0.2)
                                  : AppColors.lightGray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.r)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.network(
                                    item.productImage,
                                    height: 80.h,
                                    width: 80.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.image, size: 80.w),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productTitle,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Raleway',
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "User: ${item.userName}",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Price: \$${item.price}",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Product ID: ${item.productId}",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                if (controller.isDeleteMode.value)
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.redAccent,
                                    value: controller.selectedItems
                                        .contains(item.productId),
                                    onChanged: (bool? value) {
                                      controller
                                          .toggleSelection(item.productId);
                                    },
                                  ),
                              ],
                            ),
                          )),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
