import 'package:cosmose/Screens/Account/account_screen.dart';
import 'package:cosmose/Screens/FarmsExist/farms_exist_screen.dart';
import 'package:cosmose/Screens/HomeScreen/home_scrreen.dart';
import 'package:cosmose/Screens/NewsFeed/news_feed_screen.dart';
import 'package:cosmose/Screens/WishListScreen/wish_list_screen.dart';
import 'package:cosmose/Screens/cartScreen/cart_screen.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class BottomNavScreen extends StatelessWidget {
  final LoginResponse loginResponse;

  BottomNavScreen({super.key, required this.loginResponse});

  final BottomNavController controller = Get.put(BottomNavController());

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return FarmsExistScreen(loginResponse: loginResponse);
      case 1:
        return HomeScreen(loginResponse: loginResponse);
      case 2:
        return CartScreen(loginResponse: loginResponse);
      case 3:
        return WishListScreen(loginResponse: loginResponse);
      case 4:
        return NewsFeedScreen(loginResponse: loginResponse);
      case 5:
        return AccountScreen(loginResponse: loginResponse);
      default:
        return HomeScreen(loginResponse: loginResponse);
    }
  }

  BottomNavigationBarItem _buildNavItem(String icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Obx(
        () => SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            controller.selectedIndex.value == index
                ? AppColors.green
                : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _buildScreen(controller.selectedIndex.value),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.lightGray,
                width: 2.0,
              ),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem('assets/icons/farm.svg', 'Farms', 0),
              _buildNavItem('assets/icons/categoryicon.svg', 'Category', 1),
              _buildNavItem('assets/icons/carticon.svg', 'Cart', 2),
              _buildNavItem('assets/icons/favorite.svg', 'Favorite', 3),
              _buildNavItem('assets/icons/streamicon.svg', 'Stream', 4),
              _buildNavItem('assets/icons/profileicon.svg', 'Profile', 5),
            ],
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            selectedItemColor: AppColors.green,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:cosmose/controllers/cart_controller.dart';
// import 'package:cosmose/models/cart_model.dart';
// import 'package:cosmose/models/login_response.dart';
// import 'package:cosmose/services/my_cart_services.dart';
// import 'package:cosmose/utils/app_colors.dart';
// import 'package:cosmose/widgets/CustomElevatedButton.dart';
// import 'package:cosmose/widgets/cart_item_card.dart';
// import 'package:cosmose/widgets/cart_shimmer.dart';
// import 'package:cosmose/widgets/cart_summary_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class CartScreen extends StatefulWidget {
//   final LoginResponse loginResponse;

//   const CartScreen({super.key, required this.loginResponse});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   final CartController cartController = Get.put(CartController());

//   CartModel? cartModel;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchCartData();
//   }

//   Future<void> fetchCartData() async {
//     final cartData =
//         await MyCartServices().fetchCart(widget.loginResponse.token);
//     setState(() {
//       cartModel = cartData;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgcolor,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgcolor,
//         title: Text(
//           "Cart",
//           style: TextStyle(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Raleway',
//             color: AppColors.primaryDark,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? CartShimmer()
//           : cartModel == null || cartModel!.cartItems.isEmpty
//               ? Center(child: Text("No items in cart"))
//               : SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Items (${cartModel!.cartItems.length})",
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Raleway',
//                             color: AppColors.primaryDark,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         ListView.builder(
//                           itemCount: cartModel!.cartItems.length,
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           padding: EdgeInsets.zero,
//                           itemBuilder: (context, index) {
//                             return CartItemCard(
//                               item: cartModel!.cartItems[index],
//                               token:
//                                   widget.loginResponse.token, // Pass token here
//                             );
//                           },
//                         ),

//                         SizedBox(height: 20.h),

//                         // Delivery Options
//                         Text(
//                           "Delivery Options",
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Raleway',
//                             color: Colors.black,
//                           ),
//                         ),
//                         Obx(() => Column(
//                               children: [
//                                 ListTile(
//                                   title: Text(
//                                     "Standard Delivery",
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontFamily: 'Raleway',
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   leading: Radio(
//                                     value: "Standard Delivery",
//                                     groupValue: cartController
//                                         .selectedDeliveryOption.value,
//                                     onChanged: (value) {
//                                       cartController.changeDeliveryOption(
//                                           value.toString());
//                                     },
//                                   ),
//                                 ),
//                                 ListTile(
//                                   title: Text(
//                                     "Express Delivery",
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontFamily: 'Raleway',
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   leading: Radio(
//                                     value: "Express Delivery",
//                                     groupValue: cartController
//                                         .selectedDeliveryOption.value,
//                                     onChanged: (value) {
//                                       cartController.changeDeliveryOption(
//                                           value.toString());
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )),

//                         SizedBox(height: 10.h),

//                         // Payment Options
//                         Text(
//                           "Payment Options",
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Raleway',
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 20.h),

//                         CartSummary(
//                           subtotal: "RM${cartModel!.subTotal}",
//                           tax: "RM${cartModel!.discount}",
//                           grandTotal: "RM${cartModel!.totalAmount}",
//                         ),
//                         SizedBox(height: 20.h),
//                         CustomElevatedButton(
//                           text: "Checkout Now",
//                           onPressed: () {
//                             // Checkout logic with selected delivery option
//                             print(
//                                 "Selected Delivery Option: ${cartController.selectedDeliveryOption.value}");
//                           },
//                           color: AppColors.green,
//                           borderRadius: 11.r,
//                           height: 48.h,
//                           width: MediaQuery.of(context).size.width,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }
// }

// import 'package:cosmose/Models/get_profile_model.dart';
// import 'package:cosmose/Screens/NewsFeed/interesting_articles_details.dart';
// import 'package:cosmose/Screens/NewsFeed/latest_post_details.dart';
// import 'package:cosmose/controllers/news_feed_controller.dart';
// import 'package:cosmose/controllers/user_controller.dart';
// import 'package:cosmose/models/login_response.dart';
// import 'package:cosmose/services/get_profile_service.dart';
// import 'package:cosmose/widgets/latest_post_shimmer_widget.dart';
// import 'package:cosmose/widgets/news_feed_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class NewsFeedScreen extends StatefulWidget {
//   final LoginResponse loginResponse;

//   const NewsFeedScreen({super.key, required this.loginResponse});

//   @override
//   State<NewsFeedScreen> createState() => _NewsFeedScreenState();
// }

// class _NewsFeedScreenState extends State<NewsFeedScreen> {
//   final NewsFeedController controller = Get.put(NewsFeedController());

//   final UserController userController = Get.find<UserController>();

//   GetProfile? profileData;
//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     fetchProfileData();
//     userController.setUserName(widget.loginResponse.user.name);
//   }

//   Future<void> fetchProfileData() async {
//     UserService userService = UserService();
//     profileData =
//         await userService.fetchUserProfile(widget.loginResponse.token);
//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade200,
//         // automaticallyImplyLeading: false,
//         title: Text(
//           "Social Media News Feed",
//           style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Raleway'),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20.h),
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 20,
//                     backgroundImage: profileData?.photo != null &&
//                             profileData!.photo!['url'] != null
//                         ? NetworkImage(profileData!.photo!['url'])
//                             as ImageProvider
//                         : const AssetImage("assets/images/buyer.png"),
//                   ),
//                   SizedBox(
//                     width: 5.w,
//                   ),
//                   Obx(
//                     () => Text(
//                       userController.userName.value,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Raleway',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 "Latest Posts",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return LatestPostShimmer();
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: controller.latestPosts.length,
//                   itemBuilder: (context, index) {
//                     var post = controller.latestPosts[index];
//                     return Column(
//                       // Use Column instead of Row
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => LatestPostDetails(post: post));
//                           },
//                           child: NewsFeedCard(
//                             title: post.title,
//                             post: post.slug,
//                             imageUrl: post.image,
//                             avatarColor: Colors.orange,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                       ],
//                     );
//                   },
//                 );
//               }),
//               SizedBox(height: 15.h),
//               Text(
//                 "Featured Products",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return LatestPostShimmer();
//                 }

//                 if (controller.featuredProducts.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "Sorry, no Featured Products available",
//                       style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey),
//                     ),
//                   );
//                 }

//                 return SizedBox(
//                   height: 252.h,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: controller.featuredProducts.length,
//                     itemBuilder: (context, index) {
//                       var product = controller.featuredProducts[index];
//                       return Row(
//                         children: [
//                           FeaturedProductCard(
//                             title: product.title,
//                             photoUrl: product.photo,
//                             price: product.price,
//                           ),
//                           SizedBox(
//                             width: 10.w,
//                           )
//                         ],
//                       );
//                     },
//                   ),
//                 );
//               }),

//               SizedBox(
//                 height: 15.h,
//               ),
//               Text(
//                 "Customer Reviews",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               SizedBox(
//                 height: 106.h,
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return LatestPostShimmer();
//                   }
//                   return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: controller.latestReviews.length,
//                     padding: EdgeInsets.zero,
//                     itemBuilder: (context, index) {
//                       final review = controller.latestReviews[index];
//                       return Row(
//                         children: [
//                           ReviewCard(
//                             user: review.user,
//                             product: review.product,
//                             rating: review.rating,
//                             comment: review.comment,
//                             avatarColor: Colors.green,
//                           ),
//                           SizedBox(width: 10.w),
//                         ],
//                       );
//                     },
//                   );
//                 }),
//               ),
//               SizedBox(
//                 height: 15.h,
//               ),
//               Text(
//                 "Trending Posts",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return LatestPostShimmer();
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true, // ✅ Allows dynamic height
//                   physics: NeverScrollableScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   itemCount: controller.trendingPosts.length,
//                   itemBuilder: (context, index) {
//                     var post = controller.trendingPosts[index];
//                     return Column(
//                       children: [
//                         TrendingPostCard(
//                           title: post.title,
//                           imageUrl: post.image,
//                           summary: post.summary,
//                         ),
//                         SizedBox(
//                           height: 10.w,
//                         )
//                       ],
//                     );
//                   },
//                 );
//               }),
//               SizedBox(height: 15.h),
//               // Add this below "Trending Posts" section in NewsFeedScreen
//               SizedBox(height: 15.h),
//               Text(
//                 "Interesting Articles",
//                 style: TextStyle(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Raleway'),
//               ),
//               SizedBox(height: 5.h),
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return LatestPostShimmer();
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: controller.interestingArticles.length,
//                   itemBuilder: (context, index) {
//                     var article = controller.interestingArticles[index];
//                     return Column(
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               Get.to(() => InterestingArticlesDetails(
//                                     post: article,
//                                   ));
//                             },
//                             child: InterestingArticleCard(article: article)),
//                         SizedBox(height: 10.h),
//                       ],
//                     );
//                   },
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
