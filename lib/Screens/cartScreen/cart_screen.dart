import 'dart:convert';

import 'package:cosmose/Screens/PaymentUpForm/PaymentUpForm.dart';
import 'package:cosmose/Screens/WebViewScreen/webview_screen.dart';
import 'package:cosmose/controllers/delete_cart_controller.dart';
import 'package:cosmose/models/cart_model.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/my_cart_services.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/cart_item_card.dart';
import 'package:cosmose/widgets/cart_shimmer.dart';
import 'package:cosmose/widgets/cart_summary_widget.dart';
import 'package:cosmose/widgets/checkout_summary_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final LoginResponse loginResponse;

  const CartScreen({super.key, required this.loginResponse});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DeleteCartController deleteCartController =
      Get.put(DeleteCartController());
  CartModel? cartModel;
  bool isLoading = true;
  double? totalAmount;
  int? discount;
  int? shippingId;
  String? shippingPrice;
  bool showUpdateProfileButton = false;
  @override
  void initState() {
    super.initState();
    fetchCartData();

    print("***************************************");
    print("User Token: ${widget.loginResponse.token}");
    print("***************************************");
  }

  Future<void> checkout() async {
    final url = Uri.parse("https://cosmoseworld.fr/api/checkout");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.loginResponse.token}',
          'Content-Type': 'application/json',
        },
      );
      print("***************************************");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("***************************************");
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData["error"] == "Please Update Profile First.") {
          setState(() {
            showUpdateProfileButton = true; // Show the button
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please update your profile first."),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          // Update the state to show response data on screen
          setState(() {
            totalAmount = (responseData['total_amount'] as num).toDouble();
            discount = responseData['discount'];
            shippingId = responseData['shipping_id'];
            shippingPrice = responseData['shippingprice'];
          });
        }
      }
    } catch (e) {
      print("Checkout error: $e");
    }
  }

  Future<void> fetchCartData() async {
    final cartData =
        await MyCartServices().fetchCart(widget.loginResponse.token);
    setState(() {
      cartModel = cartData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        automaticallyImplyLeading: false,
        title: Text(
          "Cart",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Raleway',
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: isLoading
          ? CartShimmer()
          : cartModel == null || cartModel!.cartItems.isEmpty
              ? Center(child: Text("No items in cart"))
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Items (${cartModel!.cartItems.length})",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Raleway',
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Obx(
                              () => deleteCartController.isSelectionMode.value
                                  ? IconButton(
                                      icon: Icon(Icons.check,
                                          color: AppColors.green),
                                      onPressed: () async {
                                        await deleteCartController
                                            .removeFromCart(
                                                widget.loginResponse.token,
                                                fetchCartData);
                                        deleteCartController
                                            .toggleSelectionMode();
                                      },
                                    )
                                  : IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        deleteCartController
                                            .toggleSelectionMode();
                                      },
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        ListView.builder(
                          itemCount: cartModel!.cartItems.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return CartItemCard(
                              item: cartModel!.cartItems[index],
                              token: widget.loginResponse.token,
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        CartSummary(
                          subtotal: "RM${cartModel!.subTotal}",
                          tax: "RM${cartModel!.discount}",
                          grandTotal: "RM${cartModel!.totalAmount}",
                        ),
                        SizedBox(height: 10.h),
                        if (totalAmount != null && shippingPrice != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Checkout Summary",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CheckoutSummaryRow(
                                      label: "Total Amount",
                                      value: totalAmount!.toStringAsFixed(2),
                                    ),
                                    CheckoutSummaryRow(
                                      label: "Discount",
                                      value: (discount ?? 0).toString(),
                                    ),
                                    CheckoutSummaryRow(
                                      label: "Shipping ID",
                                      value: (shippingId ?? 0).toString(),
                                    ),
                                    CheckoutSummaryRow(
                                      label: "Shipping Price",
                                      value: (shippingPrice ?? '0').toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        SizedBox(height: 10.h),
                        CustomElevatedButton(
                          text: "Checkout Now",
                          onPressed: () {
                            checkout();
                          },
                          color: AppColors.green,
                          borderRadius: 11.r,
                          height: 48.h,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: 20.h),
                        if (showUpdateProfileButton)
                          CustomElevatedButton(
                            text: "Update Profile Now",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                    loginResponse: widget.loginResponse,
                                  ),
                                ),
                              );
                            },
                            color: AppColors.green,
                            borderRadius: 11.r,
                            height: 48.h,
                            width: MediaQuery.of(context).size.width,
                          ),
                        SizedBox(height: 20.h),
                        if (totalAmount != null && shippingPrice != null)
                          CustomElevatedButton(
                            text: "Place Order",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentUpForm(
                                      shippingId: shippingId ?? 0,
                                      loginResponse: widget.loginResponse),
                                ),
                              );
                            },
                            color: AppColors.green,
                            borderRadius: 11.r,
                            height: 48.h,
                            width: MediaQuery.of(context).size.width,
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
