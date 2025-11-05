import 'package:cosmose/Models/category_model.dart';
import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/Models/product_model.dart';
import 'package:cosmose/Screens/ItemsDetailsScreen/ietmdeatil.dart';
import 'package:cosmose/controllers/home_screen_controller.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/images_assets.dart';
import 'package:cosmose/utils/text_styles.dart';
import 'package:cosmose/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final LoginResponse loginResponse;

  const HomeScreen({super.key, required this.loginResponse});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final UserController userController = Get.find<UserController>();

  GetProfile? profileData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchProfileData();
    userController.setUserName(widget.loginResponse.user.name);
  }

  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData =
        await userService.fetchUserProfile(widget.loginResponse.token);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bgcolor,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Welcome to Cosmose',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      SvgPicture.asset(
                        "assets/icons/wave.svg",
                        height: 18.h,
                        width: 18.h,
                      ),
                    ],
                  ),
                  Text(
                    profileData?.name ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: profileData?.photo != null &&
                        profileData!.photo!['url'] != null
                    ? NetworkImage(profileData!.photo!['url']) as ImageProvider
                    : const AssetImage("assets/images/buyer.png"),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),

          /// **Categories List**
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Obx(() {
              if (controller.isLoading.value) return ShimmerLoader();
              if (controller.hasError.value) {
                return Center(child: Text("Failed to load categories"));
              }

              return SingleChildScrollView(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Obx(() {
                  return Row(
                    children:
                        controller.categories.asMap().entries.map((entry) {
                      int index = entry.key;
                      Category category = entry.value;

                      double normalizedOffset =
                          (controller.scrollOffset.value / 500).clamp(0.0, 1.0);
                      double scaleFactor =
                          1.0 - (normalizedOffset * 0.2); // Shrinks slightly
                      double fadeFactor =
                          1.0 - (normalizedOffset * 0.3); // Fades slightly
                      double translateX =
                          (normalizedOffset * 25.0); // Subtle parallax effect

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        transform: Matrix4.identity()
                          ..translate(-translateX, 0, 0)
                          ..scale(scaleFactor),
                        child: Opacity(
                          opacity: fadeFactor,
                          child: GestureDetector(
                            onTap: () => controller.onCategoryTap(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.selectedIndex.value == index
                                    ? AppColors.green
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 38,
                                    backgroundColor:
                                        controller.selectedIndex.value == index
                                            ? Colors.white
                                            : Colors.grey[300],
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          NetworkImage(category.photo),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.title,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedIndex.value ==
                                              index
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              );
            }),
          ),

          /// **PageView for Categories**
          Expanded(
            child: Obx(() => PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.categories.length,
                  onPageChanged: (index) {
                    controller.selectedIndex.value = index;
                  },
                  itemBuilder: (context, index) {
                    return _buildCategoryPage(controller.categories[index]);
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPage(Category category) {
    return Obx(() {
      List<Product> filteredProducts;

      // If "All" category is selected, show all products
      if (category.title.toLowerCase() == "all" ||
          category.slug.toLowerCase() == "all") {
        filteredProducts = controller.allProducts;
      } else {
        filteredProducts = controller.allProducts
            .where((product) => product.catId == category.id)
            .toList();
      }

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Result: ", style: TextStyles.bold(14.sp)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return TweenAnimationBuilder(
                  duration: Duration(
                      milliseconds: 400 + (index * 100)), // Delayed Animation
                  curve: Curves.easeOut,
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: Column(
                          children: [
                            Container(
                              height: 212.h,
                              width: 146.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                              product: product,
                                              loginResponse:
                                                  widget.loginResponse),
                                        ),
                                      );
                                      print(product.toJson());
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Image.network(
                                        product.photo,
                                        width: 146.w,
                                        height: 147.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8.h,
                                    left: 8.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        product.condition,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 50.h,
                                    right: -10.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Quick Add to cart");
                                      },
                                      child: CircleAvatar(
                                        radius: 22.r,
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            AssetImage(ImageAssets.cartbutton),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        Text(product.title,
                                            style: TextStyle(fontSize: 14.sp)),
                                        Text(
                                            "${product.price} / ${product.size}",
                                            style: TextStyle(fontSize: 14.sp)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   _ProductDetailScreenState createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.product.video != null && widget.product.video!.isNotEmpty) {
//       _controller = VideoPlayerController.network(widget.product.video!)
//         ..initialize().then((_) {
//           setState(() {}); // Refresh the widget after initializing
//         });
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(widget.product.title,
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 2,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   widget.product.photo,
//                   width: double.infinity,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),

//             // Title and Price
//             Text(widget.product.title,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Text("Price: ",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text("${widget.product.price} / ${widget.product.size}",
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold)),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Condition and Status
//             Wrap(
//               spacing: 8,
//               children: [
//                 Chip(
//                     label: Text("Condition: ${widget.product.condition}"),
//                     backgroundColor: Colors.blue.shade50),
//                 Chip(
//                     label: Text("Status: ${widget.product.status}"),
//                     backgroundColor: Colors.green.shade50),
//               ],
//             ),
//             SizedBox(height: 16),

//             // Summary
//             Text("Summary:",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text(widget.product.summary,
//                 style: TextStyle(fontSize: 16, color: Colors.black87)),
//             SizedBox(height: 16),

//             // Description
//             Text("Description:",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text(widget.product.description,
//                 style: TextStyle(fontSize: 16, color: Colors.black87)),
//             SizedBox(height: 16),

//             // Additional Images
//             if (widget.product.images.isNotEmpty) ...[
//               Text("More Images:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               SizedBox(
//                 height: 120,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: widget.product.images.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.only(right: 8),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.network(widget.product.images[index],
//                             width: 120, height: 120, fit: BoxFit.cover),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 16),
//             ],

//             // Video Preview (if available)
//             if (_controller != null) ...[
//               Text("Video Preview:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 8),
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: AspectRatio(
//                       aspectRatio: _controller!.value.aspectRatio,
//                       child: VideoPlayer(_controller!),
//                     ),
//                   ),
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.black54,
//                     child: IconButton(
//                       icon: Icon(
//                         _controller!.value.isPlaying
//                             ? Icons.pause
//                             : Icons.play_arrow,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _controller!.value.isPlaying
//                               ? _controller!.pause()
//                               : _controller!.play();
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//             ],

//             // Stock and VAT
//             Text("Stock: ${widget.product.stock}",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Text("VAT: ${widget.product.vat}",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             SizedBox(height: 16),

//             // Discount and Featured Status
//             Row(
//               children: [
//                 Text("Discount: ${widget.product.discount}%",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(width: 16),
//                 Chip(
//                   label: Text(
//                     widget.product.isFeatured == 1
//                         ? "Featured"
//                         : "Not Featured",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: widget.product.isFeatured == 1
//                       ? Colors.blue
//                       : Colors.grey,
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),

//             // Platform and Timestamps
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Platform: ${widget.product.platform}",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                         "Created: ${DateFormat('yyyy-MM-dd').format(widget.product.createdAt)}",
//                         style: TextStyle(fontSize: 14)),
//                     Text(
//                         "Updated: ${DateFormat('yyyy-MM-dd').format(widget.product.updatedAt)}",
//                         style: TextStyle(fontSize: 14)),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Button to Buy
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: () {
//                   // Add to cart or buy functionality
//                 },
//                 child: Text("Buy Now",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
