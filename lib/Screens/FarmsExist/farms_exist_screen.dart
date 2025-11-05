import 'package:cosmose/Models/get_profile_model.dart';
import 'package:cosmose/Screens/dfs.dart';
import 'package:cosmose/controllers/farms_exist_controller.dart';
import 'package:cosmose/controllers/login_animation_controller.dart';
import 'package:cosmose/controllers/user_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/get_profile_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/farm_card.dart';
import 'package:cosmose/widgets/farms_exist_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FarmsExistScreen extends StatefulWidget {
  final LoginResponse loginResponse;

  const FarmsExistScreen({super.key, required this.loginResponse});

  @override
  State<FarmsExistScreen> createState() => _FarmsExistScreenState();
}

class _FarmsExistScreenState extends State<FarmsExistScreen>
    with SingleTickerProviderStateMixin {
  final FarmsExistController controller = Get.put(FarmsExistController());
  final UserController userController = Get.find<UserController>();
  late LoginAnimationController _animationController;
  bool isLoading = true;
  GetProfile? profileData;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    _animationController = LoginAnimationController(this);
    _animationController.startAnimation();
  }

  Future<void> fetchProfileData() async {
    UserService userService = UserService();
    profileData =
        await userService.fetchUserProfile(widget.loginResponse.token);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    // Clear the postal code text field when leaving the screen
    controller.postalCodeController.clear();
    _animationController.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SlideTransition(
          position: _animationController.emailAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Cosmose',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    profileData?.name ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  )
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: AssetImage("assets/images/applogo.png"),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: _animationController.emailAnimation,
                child: Text.rich(
                  TextSpan(
                    text: "Find farms nearby",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Raleway',
                      color: AppColors.primaryDark,
                    ),
                    children: [
                      TextSpan(
                        text: "\nInstantly",
                        style: TextStyle(
                          color: AppColors.green,
                        ),
                      ),
                      TextSpan(
                        text: " just enter",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: " \nYour",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: " Postal Code!",
                        style: TextStyle(
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SlideTransition(
                position: _animationController.emailAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 42.h,
                      width: 258.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.r),
                          topLeft: Radius.circular(5.r),
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: controller.postalCodeController,
                        cursorColor: AppColors.green,
                        decoration: InputDecoration(
                          hintText: "Enter postal code",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 1.w),
                    GestureDetector(
                      onTap: controller.fetchFarms,
                      child: Container(
                        height: 42.h,
                        width: 75.w,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.r),
                            bottomRight: Radius.circular(5.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Search",
                            style: TextStyle(
                              fontSize: 16.sp,
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
              ),
              SizedBox(height: 20.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return const FarmsExistShimmer();
                } else if (controller.errorMessage.value != null) {
                  Future.delayed(Duration.zero, () {
                    Get.snackbar(
                      "Error",
                      controller.errorMessage.value!,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: Duration(seconds: 3),
                    );
                  });
                  return SizedBox();
                } else if (controller.farmList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SlideTransition(
                            position: _animationController.emailAnimation,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 80,
                              backgroundImage:
                                  AssetImage("assets/images/searchgif.gif"),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          if (controller.postalCodeController.text.isNotEmpty)
                            Text(
                              "No farms found for this postal code.",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.farmList.length,
                    itemBuilder: (context, index) {
                      final farm = controller.farmList[index];
                      return FarmCard(
                        name: farm.name,
                        address: farm.address1 ?? "No Address",
                        postalCode: farm.postalCode,
                        imageUrl: farm.photo,
                        onViewDetails: () {
                          Get.to(() => FarmerProfileDetails(
                                farm: farm,
                                loginResponse: widget.loginResponse,
                              ));
                        },
                      );
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
