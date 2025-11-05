import 'dart:convert';

import 'package:cosmose/controllers/delete_cart_controller.dart';
import 'package:cosmose/models/cart_model.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartItemCard extends StatefulWidget {
  final CartItem item;
  final String token;

  const CartItemCard({
    super.key,
    required this.item,
    required this.token,
  });

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int quantity;
  final DeleteCartController deleteCartController = Get.find();

  @override
  void initState() {
    super.initState();

    quantity = widget.item.quantity; // Initialize with the current quantity
  }

  // Function to update quantity using PUT API
  Future<void> updateCartQuantity(int newQuantity) async {
    final String url = "https://cosmoseworld.fr/api/cart/update";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "cart_id": widget.item.id, // Sending cart ID
          "quantity": newQuantity, // Sending updated quantity
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          quantity = newQuantity; // Update UI
        });
        print("Cart updated successfully: ${response.body}");
      } else {
        print("Failed to update cart: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error updating cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.button2,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Product Image
                if (deleteCartController.isSelectionMode.value)
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: AppColors.green,
                    value: deleteCartController.pro_id
                        .contains(widget.item.productId),
                    onChanged: (value) {
                      deleteCartController
                          .toggleItemSelection(widget.item.productId);
                    },
                  ),

                Container(
                  height: 53.h,
                  width: 52.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: NetworkImage(widget.item.productImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                /// Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.productTitle,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway',
                          color: AppColors.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "RM ${widget.item.price} / per pkg",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway',
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Quantity Adjustment
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          updateCartQuantity(quantity - 1);
                        }
                      },
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.remove,
                            color: Colors.black, size: 18.sp),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      height: 37.h,
                      width: 34.w,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$quantity", // Display updated quantity
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Raleway',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () {
                        updateCartQuantity(quantity + 1);
                      },
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: Colors.grey.shade300,
                        child:
                            Icon(Icons.add, color: Colors.black, size: 18.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Divider(),
        ],
      ),
    );
  }
}
