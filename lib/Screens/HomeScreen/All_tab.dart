import 'package:cosmose/utils/images_assets.dart';
import 'package:cosmose/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllTabScreen extends StatelessWidget {
  const AllTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
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
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.7,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Column(
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.asset(
                                "assets/images/farmar1.png",
                                width: 146.w,
                                height: 147.h,
                                fit: BoxFit.cover,
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
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  "condition",
                                  style: TextStyles.bold(12.sp)
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 50.h,
                              right: -10.w,
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
                            Positioned(
                              bottom: 10.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text("title", style: TextStyles.body(14.sp)),
                                  Text("price/size",
                                      style: TextStyles.body(14.sp)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:cosmose/Models/category_model.dart';
// import 'package:cosmose/Models/product_model.dart';
// import 'package:cosmose/controllers/home_screen_controller.dart';
// import 'package:cosmose/utils/app_colors.dart';
// import 'package:cosmose/utils/images_assets.dart';
// import 'package:cosmose/utils/text_styles.dart';
// import 'package:cosmose/widgets/shimmer_loader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   final HomeController controller = Get.put(HomeController());

//   HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgcolor,
//       // appBar: AppBar(
//       //   backgroundColor: AppColors.bgcolor,
//       //   automaticallyImplyLeading: false,
//       //   actions: [
//       //     Image.asset(
//       //       ImageAssets.cosmoselogo,
//       //       width: 50.w,
//       //       height: 50.h,
//       //     ),
//       //   ],
//       // ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(height: 60.h),
//           Center(
//             child: Image.asset(
//               ImageAssets.cosmoselogo,
//               width: 92.w,
//               height: 77.h,
//             ),
//           ),
//           SizedBox(height: 20.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//             child: Obx(() {
//               if (controller.isLoading.value) return ShimmerLoader();
//               if (controller.hasError.value) {
//                 return Center(
//                     child: Text("Failed to load categories",
//                         style: TextStyles.body(14.sp)));
//               }

//               return SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.15,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: controller.categories.length,
//                   separatorBuilder: (_, __) => SizedBox(width: 12.w),
//                   itemBuilder: (context, index) {
//                     Category category = controller.categories[index];

//                     return GestureDetector(
//                       onTap: () => controller.onCategoryTap(index),
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 32.r,
//                             backgroundColor:
//                                 controller.selectedIndex.value == index
//                                     ? AppColors.green
//                                     : AppColors.lightGray,
//                             child: CircleAvatar(
//                               radius: 30.r,
//                               backgroundImage: NetworkImage(category.photo),
//                             ),
//                           ),
//                           SizedBox(height: 6.h),
//                           Text(
//                             category.title,
//                             textAlign: TextAlign.center,
//                             style: TextStyles.body(14.sp).copyWith(
//                               color: controller.selectedIndex.value == index
//                                   ? AppColors.green
//                                   : AppColors.lightGray,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }),
//           ),

//           /// **Categories List**
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//             child: Obx(() {
//               if (controller.isLoading.value) return ShimmerLoader();
//               if (controller.hasError.value) {
//                 return Center(child: Text("Failed to load categories"));
//               }

//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: controller.categories.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     Category category = entry.value;

//                     return GestureDetector(
//                       onTap: () => controller.onCategoryTap(index),
//                       child: Obx(() => Container(
//                             margin: EdgeInsets.only(right: 10.w),
//                             height: MediaQuery.of(context).size.height * 0.12,
//                             width: MediaQuery.of(context).size.width * 0.22,
//                             decoration: BoxDecoration(
//                               color: controller.selectedIndex.value == index
//                                   ? AppColors.green
//                                   : AppColors.lightGray,
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(8.h),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width: 40.w,
//                                     height: 40.h,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8.r),
//                                       image: DecorationImage(
//                                         image: NetworkImage(category.photo),
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 5.h),
//                                   Expanded(
//                                     child: Text(
//                                       category.title,
//                                       textAlign: TextAlign.center,
//                                       style: TextStyles.body(12.sp).copyWith(
//                                         color: controller.selectedIndex.value ==
//                                                 index
//                                             ? Colors.white
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }),
//           ),

//           /// **PageView for Categories**
//           Expanded(
//             child: Obx(() => PageView.builder(
//                   controller: controller.pageController,
//                   itemCount: controller.categories.length,
//                   onPageChanged: (index) {
//                     controller.selectedIndex.value = index;
//                   },
//                   itemBuilder: (context, index) {
//                     return _buildCategoryPage(controller.categories[index]);
//                   },
//                 )),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryPage(Category category) {
//     return Obx(() {
//       List<Product> filteredProducts;

//       // If "All" category is selected, show all products
//       if (category.title.toLowerCase() == "all" ||
//           category.slug.toLowerCase() == "all") {
//         filteredProducts = controller.allProducts;
//       } else {
//         filteredProducts = controller.allProducts
//             .where((product) => product.catId == category.id)
//             .toList();
//       }

//       return Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text("Result: ", style: TextStyles.bold(14.sp)),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.search, color: Colors.black),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.filter_list, color: Colors.black),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.zero,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 0.w,
//                 mainAxisSpacing: 0.h,
//                 childAspectRatio: 0.8,
//               ),
//               itemCount: filteredProducts.length,
//               itemBuilder: (context, index) {
//                 final product = filteredProducts[index];
//                 return Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         // Print entire product details in one line
//                         print(product.toJson());
//                       },
//                       child: Container(
//                         height: 212.h,
//                         width: 146.w,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16.r),
//                         ),
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           alignment: Alignment.topCenter,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(16.r),
//                               child: Image.network(
//                                 product.photo,
//                                 width: 146.w,
//                                 height: 147.h,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Positioned(
//                               top: 8.h,
//                               left: 8.w,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 6.w, vertical: 4.h),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(8.r),
//                                 ),
//                                 child: Text(
//                                   product.condition,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12.sp,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 50.h,
//                               right: -10.w,
//                               child: CircleAvatar(
//                                 radius: 22.r,
//                                 backgroundColor: Colors.white,
//                                 backgroundImage:
//                                     AssetImage(ImageAssets.cartbutton),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(4.r),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 10.h,
//                               left: 0,
//                               right: 0,
//                               child: Column(
//                                 children: [
//                                   Text(product.title,
//                                       style: TextStyle(fontSize: 14.sp)),
//                                   Text("${product.price} / ${product.size}",
//                                       style: TextStyle(fontSize: 14.sp)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

// Padding(
//   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//   child: Obx(() {
//     if (controller.isLoading.value) return ShimmerLoader();
//     if (controller.hasError.value) {
//       return Center(child: Text("Failed to load categories", style: TextStyles.body(14.sp)));
//     }

//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.14,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: controller.categories.length,
//         separatorBuilder: (_, __) => SizedBox(width: 12.w),
//         itemBuilder: (context, index) {
//           Category category = controller.categories[index];
//           bool isSelected = controller.selectedIndex.value == index;

//           return GestureDetector(
//             onTap: () => controller.onCategoryTap(index),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 30.r,
//                   backgroundImage: NetworkImage(category.photo),
//                 ),
//                 SizedBox(height: 6.h),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: isSelected ? AppColors.green : Colors.transparent,
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Text(
//                     category.title,
//                     textAlign: TextAlign.center,
//                     style: TextStyles.body(13.sp).copyWith(
//                       color: isSelected ? Colors.white : Colors.black87,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }),
// )
