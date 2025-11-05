import 'package:cosmose/Auth/login_screen.dart';
import 'package:cosmose/controllers/login_animation_controller.dart';
import 'package:cosmose/controllers/signup_controller.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/images_assets.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final SignupController controller = Get.put(SignupController());
  late LoginAnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = LoginAnimationController(this);
    _animationController.startAnimation();
  }

  @override
  void dispose() {
    _animationController.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FadeTransition(
                    opacity: _animationController.logoFadeAnimation,
                    child: Image.asset(
                      ImageAssets.cosmoselogo,
                      width: 92.w,
                      height: 77.h,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: FadeTransition(
                    opacity: _animationController.logoFadeAnimation,
                    child: Text(
                      "Create An Account",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Raleway',
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                /// **Full Name Field**
                SlideTransition(
                  position: _animationController.emailAnimation,
                  child: CustomTextField(
                    label: "Full Name *:",
                    hintText: "Enter your full name",
                    controller: controller.nameController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(height: 20.h),

                /// **Email Field**
                SlideTransition(
                  position: _animationController.emailAnimation,
                  child: CustomTextField(
                    label: "Email Address *:",
                    hintText: "Enter your email",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20.h),

                /// **Password Field**
                Obx(
                  () => SlideTransition(
                    position: _animationController.emailAnimation,
                    child: CustomTextField(
                      label: "Password *:",
                      hintText: "Enter your password",
                      controller: controller.passwordController,
                      isPassword: true,
                      obscureText: !controller.isPasswordVisible.value,
                      togglePasswordVisibility: () {
                        controller.isPasswordVisible.toggle();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                /// **Confirm Password Field**
                Obx(
                  () => SlideTransition(
                    position: _animationController.emailAnimation,
                    child: CustomTextField(
                      label: "Confirm Password *:",
                      hintText: "Re-enter your password",
                      controller: controller.confirmPasswordController,
                      isPassword: true,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      togglePasswordVisibility: () {
                        controller.isConfirmPasswordVisible.toggle();
                      },
                      onChanged: (value) {
                        controller.validatePasswords();
                      },
                    ),
                  ),
                ),

                /// **Show Password Error if Not Matching**
                Obx(
                  () => controller.passwordError.value != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 5.h, left: 10.w),
                          child: Text(
                            controller.passwordError.value!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(height: 25.h),

                /// **Register Button**
                Obx(
                  () => SlideTransition(
                    position: _animationController.emailAnimation,
                    child: CustomElevatedButton(
                      text: "Register",
                      onPressed: controller.isLoading.value
                          ? () {} // ✅ Provide an empty function instead of null
                          : controller.registerUser,
                      color: controller.isLoading.value
                          ? Colors.grey
                          : AppColors.green, // ✅ Change color when loading
                      borderRadius: 11.r,
                      height: 48.h,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: SlideTransition(
                      position: _animationController.emailAnimation,
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Raleway',
                            color: AppColors.primaryDark,
                          ),
                          children: [
                            TextSpan(
                              text: "Login Now",
                              style: TextStyle(
                                color: AppColors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
