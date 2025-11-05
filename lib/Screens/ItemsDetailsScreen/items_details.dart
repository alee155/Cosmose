// import 'package:cosmose/controllers/item_details_controller.dart';
// import 'package:cosmose/utils/app_colors.dart';
// import 'package:cosmose/utils/text_styles.dart';
// import 'package:cosmose/widgets/CustomElevatedButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class ItemsDetailsScreen extends StatelessWidget {
//   const ItemsDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ItemDetailsController controller = Get.put(ItemDetailsController());

//     return Scaffold(
//       body: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Positioned(
//                 top: 0.h,
//                 left: 0.w,
//                 right: 0.w,
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: 283.h,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         image: DecorationImage(
//                           image: AssetImage("assets/images/farmar1.png"),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 50.h,
//                       right: 10.w,
//                       child: Container(
//                         width: 70.w,
//                         height: 200.h,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                         ),
//                         child: SizedBox(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.vertical,
//                             itemCount: 5,
//                             padding: EdgeInsets.zero,
//                             itemBuilder: (context, index) {
//                               return Column(
//                                 children: [
//                                   Container(
//                                     width: 70.w,
//                                     height: 70.h,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(10.r),
//                                       ),
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10.h)
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Positioned(
//               top: 40.h,
//               left: 20.w,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.arrow_back_ios_new, color: AppColors.green),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 237.h,
//               left: 0.w,
//               right: 0.w,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50.r),
//                     topRight: Radius.circular(50.r),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 30.h),
//                       Text("Orange", style: TextStyles.bold(32.sp)),
//                       Text("RM 10.00 / per pkg", style: TextStyles.body(18.sp)),
//                       SizedBox(height: 10.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: controller.decrement,
//                                 child: CircleAvatar(
//                                   backgroundColor: Colors.grey.shade300,
//                                   child:
//                                       Icon(Icons.remove, color: Colors.black),
//                                 ),
//                               ),
//                               SizedBox(width: 10.w),
//                               Obx(
//                                 () => Text(
//                                   "${controller.quantity.value}",
//                                   style: TextStyles.bold(18.sp),
//                                 ),
//                               ),
//                               SizedBox(width: 10.w),
//                               GestureDetector(
//                                 onTap: controller.increment,
//                                 child: CircleAvatar(
//                                   backgroundColor: Colors.grey.shade300,
//                                   child: Icon(Icons.add, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Obx(
//                             () => GestureDetector(
//                               onTap: controller.toggleFavorite,
//                               child: CircleAvatar(
//                                 backgroundColor: controller.isFavorite.value
//                                     ? Colors.red.shade100
//                                     : Colors.grey.shade300,
//                                 child: Icon(
//                                   Icons.favorite,
//                                   color: controller.isFavorite.value
//                                       ? Colors.red
//                                       : Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Divider(),
//                       SizedBox(height: 10.h),
//                       Text(
//                         "Oranges are round orange-coloured fruit that grow on a tree which can reach 10 metres (33 ft) high. Orange trees have dark green shiny leaves and small white flowers with five petals. The flowers smell very sweet which attracts many bees. An orange has a tough shiny orange skin.",
//                         style: TextStyles.body(14.sp),
//                       ),
//                       SizedBox(height: 40.h),
//                       CustomElevatedButton(
//                         text: "Add To Cart",
//                         onPressed: () {},
//                         color: AppColors.green,
//                         borderRadius: 11.r,
//                         height: 48.h,
//                         width: MediaQuery.of(context).size.width,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
