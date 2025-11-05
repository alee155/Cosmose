import 'package:cosmose/Auth/signup_screen.dart';
import 'package:cosmose/Screens/BottomNavBarScreen/bottomNavBar_screen.dart';
import 'package:cosmose/controllers/login_animation_controller.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/login_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/images_assets.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:cosmose/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  final RxBool _rememberMe = false.obs;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginAnimationController _animationController;
  final RxBool _isLoading = false.obs; // Add loading state

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

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      MotionToast.warning(
        title: const Text("Warning ⚠"),
        description: const Text("Please enter email and password."),
      ).show(context);
      return;
    }

    _isLoading.value = true; // Show loading
    try {
      final LoginResponse? response = await LoginService.loginUser(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe.value,
      );

      if (response != null) {
        if (_rememberMe.value) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', _emailController.text);
          await prefs.setString('password', _passwordController.text);
          await prefs.setString('token', response.token);
          print(
              "*********Stored TOKEN in SharedPreferences*********: ${response.token}");
        }

        MotionToast.success(
          title: Text(
            "Welcome 🎉",
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          description: Text(
            "Hello, ${response.user.name}!",
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ).show(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavScreen(loginResponse: response),
          ),
        );
      } else {
        MotionToast.error(
          title: Text(
            "Login Failed",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Raleway',
            ),
          ),
          description: Text(
            "Invalid email or password. Try again!",
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Raleway',
              color: Colors.white,
            ),
          ),
        ).show(context);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      MotionToast.error(
        title: Text(
          "Error 🚨",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        description: Text(
          "Something went wrong. Please try again!",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ).show(context);
    } finally {
      _isLoading.value = false; // Hide loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white, automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **Logo**
                Center(
                  child: FadeTransition(
                    opacity: _animationController.logoFadeAnimation,
                    child: Image.asset(
                      ImageAssets.cosmoselogo,
                      width: 120.w,
                      height: 127.h,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: FadeTransition(
                    opacity: _animationController.logoFadeAnimation,
                    child: Text(
                      "Login",
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


                /// **Email Field**
                SlideTransition(
                  position: _animationController.emailAnimation,
                  child: CustomTextField(
                    label: "Email Address:",
                    hintText: "Enter your email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20.h),

                /// **Password Field**
                SlideTransition(
                  position: _animationController.emailAnimation,
                  child: CustomTextField(
                    label: "Password:",
                    hintText: "Enter your password",
                    controller: _passwordController,
                    isPassword: true,
                    obscureText: !_isPasswordVisible,
                    togglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10.h),

                /// **Remember Me Checkbox**
                Obx(() => SlideTransition(
                      position: _animationController.emailAnimation,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _rememberMe.value,
                            onChanged: (value) {
                              _rememberMe.value = value!;
                            },
                            activeColor: AppColors.green,
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Raleway',
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    )),

                SizedBox(height: 10.h),

                /// **Login Button**
                Obx(
                  () => _isLoading.value
                      ? Center(
                          child: SpinKitFadingCube(
                            color: AppColors.green,
                            size: 35.0,
                          ),
                        )
                      : SlideTransition(
                          position: _animationController.emailAnimation,
                          child: CustomElevatedButton(
                            text: "Login",
                            onPressed: _login,
                            color: AppColors.green,
                            borderRadius: 11.r,
                            height: 48.h,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                ),
                SizedBox(height: 15.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => SignupScreen());
                    },
                    child: SlideTransition(
                      position: _animationController.emailAnimation,
                      child: Text.rich(
                        TextSpan(
                          text: "Dont have an account? ",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Raleway',
                            color: AppColors.primaryDark,
                          ),
                          children: [
                            TextSpan(
                              text: "Signup",
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
